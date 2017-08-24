(import lua/coroutine co)
(import lua/debug debug)
(import extra/term term)
(import lua/table table)

(import urn/backend/lua backend)
(import urn/logger logger)
(import urn/range range)
(import urn/resolve/walk resolve)
(import urn/resolve/scope scope)
(import urn/resolve/state state)
(import urn/timer timer)

(defun distance (a b)
  "Compute a variation of the levenshtein distance of A and B."
  :hidden
  (cond
    [(= a b) 0]
    [(= (n a) 0) (n b)]
    [(= (n b) 0) (n a)]

    [true
     (let [(v0 '())
           (v1 '())]
       ;; Setup v0 where v0[i] is the edit distance for an empty a.
       (for i 1 (succ (n b)) 1
         (push-cdr! v0 (pred i))
         (push-cdr! v1 0))

       (for i 1 (n a) 1
         ;; Calculate crrent row distance from previous v0

         ;; Edit distance is to delete i characters from a to match b.
         (.<! v1 1 i)

         (for j 1 (n b) 1
           (let [(sub-cost 1)
                 (del-cost 1)
                 (add-cost 1)
                 (a-char (string/char-at a i))
                 (b-char (string/char-at b j))]

             ;; We make "-" and "/" half as expensive as they are
             ;; separators betwen modules

             (when (= a-char b-char) (set! sub-cost 0))
             (when (or (= a-char "-") (= a-char "/")) (set! del-cost 0.5))
             (when (or (= b-char "-") (= b-char "/")) (set! add-cost 0.5))

             ;; if either string is 5 characters or less, then make
             ;; deleting and substituting more expensive. For such short
             ;; strings it is awfully easy for a string to be entirely
             ;; deleted and replaced again, resulting in rather useless
             ;; results.
             (when (or (<= (n a) 5) (<= (n b) 5))
               (set! sub-cost (* sub-cost 2))
               (set! del-cost (+ del-cost 0.5)))

             (.<! v1 (succ j) (math/min
                                (+ (nth v1 j) del-cost)
                                (+ (nth v0 (succ j)) add-cost)
                                (+ (nth v0 j) sub-cost)))))

         (for j 1 (n v0) 1 (.<! v0 j (nth v1 j))))

       (nth v1 (succ (n b))))]))

(defun compile (compiler nodes scope name)
  "Attempt to resolve all variables in a list of expressions, expanding
   all macros and what not.

   This firstly creates a State for each expression in the list. This
   tracks all variables this state references, along with the variable it
   defines, the fully built node, and (if required) the compiled value.

   These states are inserted into a task list and resolution
   starts. Actual variable resolution is only done in the resolver,
   yielding out if a variable cannot be found or in a couple of other
   cases. Each entry in this task list goes through a series of stages:

    - init: The initial state before anything has happened.

    - define: Waiting for a variable to be defined.

    - build: Waiting for another node to finish being resolved. This is
      required before we actually compile a node as we need to gather all
      its dependencies.

    - execute: Waiting for a state to execute. This is generally entered
      when the state's node needs to execute a macro which hasn't been
      compiled to Lua yet.

    - import: When we need to load and import and external module.

   Once each task's dependencies have been resolved then resolution of
   that node will continue.

   This rather convoluted algorithm does mean that statements may not
   resolve or execute in order, leading to issues where a top level
   definition shadows an imported one, as the imported one may be used
   instead. Whilst the algorithm is, strictly speaking, deterministic, it
   isn't clear when nodes will be executed.

   A future improvement of this would be to execute as much as possible
   of one node before continuing, though this places a much stricter
   requirement on definition order."
  (let [(queue '())
        (states '())
        (loader (.> compiler :loader))
        (logger (.> compiler :log))
        (timer (.> compiler :timer))]

    (when name (set! name (.. "[resolve] " name)))

    (destructuring-bind [(?hook ?hook-mask ?hook-count) (list (debug/gethook))]
      ;; Create the initial resolver states
      (for i 1 (n nodes) 1
        (let [(node (nth nodes i))
              (state (state/create scope compiler))
              (co (co/create resolve/resolve))]

          (push-cdr! states state)
          (when hook (debug/sethook co hook hook-mask hook-count))

          (push-cdr! queue { :tag "init"
                             :node node

                             ;; General state for every action
                             :_co    co
                             :_state state
                             :_node  node
                             :_idx   i })))

      (let* [(skipped 0)
             (resume (lambda (action &args)
                       ;; Reset the iteration count: something worked!
                       (set! skipped 0)

                       ;; Restore the comp0iler scope/node
                       (.<! compiler :active-scope (.> action :_active-scope))
                       (.<! compiler :active-node  (.> action :_active-node))

                       (destructuring-bind [(?status ?result) (list (co/resume (.> action :_co) (unpack args 1 (n args))))]
                         (cond
                           [(! status) (fail! result)]
                           [(= (co/status (.> action :_co)) "dead")
                            ;; We've successfully built the node, so we handle unpacking it.

                            (if (= (.> result :tag) "many")
                              (with (base-idx (.> action :_idx))
                                ;; We got multiple nodes, so we need to inject them all and adjust the other nodes' index
                                (logger/put-debug! logger "  Got multiple nodes as a result. Adding to queue")

                                ;; Increment each element after this one by (n - 1).
                                (for-each elem queue
                                  (when (> (.> elem :_idx) (.> action :_idx))
                                    (.<! elem :_idx (+ (.> elem :_idx) (pred (n result))))))

                                (for i 1 (n result) 1
                                  ;; Create a whole set of new states
                                  (with (state (state/create scope compiler))
                                    (if (= i 1)
                                      (.<! states base-idx state)
                                      (insert-nth! states (+ base-idx (pred i)) state))

                                    ;; And add them to the task list
                                    (with (co (co/create resolve/resolve))
                                      (when hook (debug/sethook co hook hook-mask hook-count))
                                      (push-cdr! queue { :tag  "init"
                                                         :node (nth result i)

                                                         :_co    co
                                                         :_state state
                                                         :_node  (nth result i)
                                                         :_idx   (+ base-idx (pred i)) })))))

                              ;; We've just got one node so we can just mark the existing one as "built".
                              (state/built! (.> action :_state) result))]
                           [true
                            ;; Copy across the general state
                            (.<! result :_co    (.> action :_co))
                            (.<! result :_state (.> action :_state))
                            (.<! result :_node  (.> action :_node))
                            (.<! result :_idx   (.> action :_idx))

                            ;; Save the active scope/node to be restored later.
                            (.<! result :_active-scope (.> compiler :active-scope))
                            (.<! result :_active-node (.> compiler :active-node))

                            ;; Requeue the node
                            (push-cdr! queue result)]))

                       ;; Clear the active scope/node so it is fresh for other expressions.
                       (.<! compiler :active-scope nil)
                       (.<! compiler :active-node nil)))]

        (when name (timer/start-timer! timer name 2))

        (while (and (> (n queue) 0) (<= skipped (n queue)))
          (with (head (remove-nth! queue 1))
            (logger/put-debug! logger
              (..
                (.> head :tag) " for " (.> head :_state :stage) " at " (range/format-node (.> head :_node))
                " (" (if (.> head :_state :var) (.> head :_state :var :name) "?") ")"))

            (case (.> head :tag)
              ["init"
               ;; We're in the inital state, so we just start the resolver with the
               ;; initial data
               (resume head (.> head :node) scope (.> head :_state))]
              ["define"
               ;; We're waiting for a variable to be defined.
               ;; If it exists, then resume the resolver. Otherwise we'll requeue.
               (if (.> scope :variables (.> head :name))
                 (resume head (.> scope :variables (.> head :name)))
                 (progn
                   (logger/put-debug! logger (.. "  Awaiting definiion of " (.> head :name)))

                   (inc! skipped)
                   (push-cdr! queue head)))]
              ["build"
               ;; We're waiting another node to finish being resolved.
               ;; If it has then we resume, otherwise we requeue.
               (if (/= (.> head :state :stage) "parsed")
                 (resume head)
                 (progn
                   (logger/put-debug! logger (.. "  Awaiting building of node "
                                               (if (.> head :state :var) (.> head :state :var :name) "?")))

                   (inc! skipped)
                   (push-cdr! queue head)))]
              ["execute"
               (backend/execute-states (.> compiler :compile-state) (.> head :states) (.> compiler :global))
               (resume head)]
              ["import"
               (when name (timer/pause-timer! timer name))

               (let* [(result (loader (.> head :module)))
                      (module (car result))]

                 (when name (timer/start-timer! timer name))

                 (unless module
                   (logger/do-node-error! logger
                     (nth result 2)
                     (.> head :_node) nil
                     (range/get-source (.> head :_node)) ""))

                 (let* [(export (.> head :export))
                        (scope (.> head :scope))
                        (node (.> head :_node))]
                   (for-pairs (name var) (.> module :scope :exported)
                     (cond
                       [(.> head :as)
                        (scope/import-verbose! scope (.. (.> head :as) "/" name)
                          var node export logger)]
                       [(.> head :symbols)
                        (when (.> head :symbols name)
                          (scope/import-verbose! scope name var node export logger))]
                       [true
                        (scope/import-verbose! scope name var node export logger)])))



                 (when (.> head :symbols)
                   (with (failed false)
                     (for-pairs (name name-node) (.> head :symbols)
                       (unless (.> module :scope :exported name)
                         (logger/put-node-error! logger
                           (.. "Cannot find " name)
                           name-node nil
                           (range/get-source (.> head :_node)) "Importing here"
                           (range/get-source (.> name-node)) "Required here")))

                     (when failed (fail! "Node resolution failed")))))

               (resume head)])))))

    (when (> (n queue) 0)
      (for-each entry queue
        (case (.> entry :tag)
          ["define"
           (let* [(info nil)
                  (suggestions "")]

             (when-with (scope (.> entry :scope))
               (let [(vars '())
                     (var-dis '())
                     (var-set {})
                     (distances {})]

                 (while scope
                   (for-pairs (name _) (.> scope :variables)
                     (unless (.> var-set name)
                       (.<! var-set name :true)
                       (push-cdr! vars name)

                       (let* [(parlen (n (.> entry :name)))
                              (lendiff (math/abs (- (n name) parlen)))]

                         ;; If there is a significant length difference and the string isn't really short then let's not
                         ;; use a variable guesser
                         (when (or (<= parlen 5) (<= lendiff (* parlen 0.3)))
                           (with (dis (/ (distance name (.> entry :name)) parlen))
                             (when (<= parlen 5) (set! dis (/ dis 2)))

                             (push-cdr! var-dis name)
                             (.<! distances name dis))))))

                   (set! scope (.> scope :parent)))

                 (table/sort vars)
                 (table/sort var-dis (lambda (a b) (< (.> distances a) (.> distances b))))

                 (with (elems (-> var-dis
                                (filter (lambda (x) (<= (.> distances x) 0.5)) <>)
                                (take <> 5)
                                (map (cut term/colored "1;32" <>) <>)))
                   (case (n elems)
                     [0]
                     [1 (set! suggestions (.. "\nDid you mean '" (car elems) "'?"))]
                     [_
                      (with (indent "\n  \xE2\x80\xA2")
                        (set! suggestions (.. "\nDid you mean any of these?" indent (concat elems indent))))]))

                 (set! info (.. "Variables in scope are " (concat vars ", ")))))

             (logger/put-node-error! logger
               (.. "Cannot find variable '" (.> entry :name) "'" suggestions)
               (or (.> entry :node) (.> entry :_node)) info
               (range/get-source (or (.> entry :node) (.> entry :_node))) ""))]
          ["build"
           (let [(var (.> entry :state :var))
                 (node (.> entry :state :node))]
             (logger/put-error! logger (.. "Could not build "
                                         (cond
                                           [var (.> var :name)]
                                           [node (range/format-node node)]
                                           [true "unknown node"]))))]))

      (fail! "Node resolution failed"))


    (when name (timer/stop-timer! timer name))

    (unpack (list
              (map (on :node) states)
              states))))
