"Provides an implementation of directed graphs.

 This provides basic algorithms for working with graphs, support for
 super-vertices, and other nifty features."

(import data/struct ())
(import data/format ())

(defstruct graph
  "Create a new, empty graph."
  (fields
    (immutable (hide vertices))
    (immutable (hide vertex-lookup)))
  (constructor new
    (lambda () (new '() {}))))

(defstruct (vertex (hide make-vertex) vertex?)
  "Create a vertex associated with a graph."
  (fields
    (immutable value (hide vertex-value))
    (immutable graph (hide vertex-graph))
    (immutable in-edges (hide vertex-in-edges))
    (immutable out-edges (hide vertex-out-edges))))

(defmethod (pretty graph) (graph)
  (.. "«graph: " (concat (map (lambda (x) (pretty (vertex-value x))) (graph-vertices graph)) " ") "»"))

(defun graph->dot (graph (name "this_graph"))
  "Convert GRAPH to a string in the DOT format, suitable for consumption
   with GraphViz."
  (assert-type! graph graph)

  (with (buffer '())
    (push! buffer (.. "digraph " name " {\n"))

    (for-each node (graph-vertices graph)
      (for-pairs (next _) (vertex-out-edges node)
        (push! buffer (string/format "  %s -> %s\n"
                            (string/quoted (pretty (vertex-value node)))
                            (string/quoted (pretty (vertex-value next)))))))

    (push! buffer "}\n")
    (concat buffer)))

(defun add-vertex! (graph value)
  "Create a vertex with the corresponding VALUE and add it to the GRAPH."
  (assert-type! graph graph)
  (when (= value nil)
    (format 1 "(add-vertex! {#graph} {#value}): vertex value cannot be nil"))
  (when (.> graph :vertex-lookup value)
    (format 1 "(add-vertex! {#graph} {#value}): value already has a corresponding vertex"))

  (with (vertex (make-vertex value graph {} {}))
    (push! (graph-vertices graph) vertex)
    (.<! (graph-vertex-lookup graph) value vertex)
    vertex))

(defun get-vertex (graph value)
  "Get the corresponding vertex for this VALUE from the given GRAPH."
  (assert-type! graph graph)
  (.> (graph-vertex-lookup graph) value))

(defmethod (pretty vertex) (vertex)
  (.. "«vertex: " (pretty (vertex-value vertex)) "»"))

(defun add-edge! (from to)
  "Add an edge FROM one vertex TO another."
  (assert-type! from vertex)
  (assert-type! to   vertex)

  (when (/= (vertex-graph from) (vertex-graph to))
    (format 1 "(add-edge! {#from} {#to}): vertex value cannot be nil"))

  (.<! (vertex-out-edges from) to   true)
  (.<! (vertex-in-edges  to)   from true)
  nil)

(defun strongly-connected-components (graph)
  "Find all strong components from a GRAPH.

   This uses Tarjan's strongly connected components algorithm, which runs
   in linear time.

   ### Example:
   ```cl
   > (define g (make-graph))
   > (let [(a (add-vertex! g :a))
   .       (b (add-vertex! g :b))
   .       (c (add-vertex! g :c))]
   .   (add-edge! a b)
   .   (add-edge! b a)
   .   (add-edge! a c))
   > (strongly-connected-components g)
   out = ((«vertex: \"c\"») («vertex: \"b\"» «vertex: \"a\"»))
   ```"
  ; hack: (hydraz)
  ; we don't have a specialised struct definition for the vertices
  ; here (as they have 3 extra fields when compared to the regular ones:
  ; `on-stack`, `low-link` and `index`). best possible solution is, imo,
  ; adding subtyping to defstruct. we'll see.
  (assert-type! graph graph)

  (let [(result '())
        (stack  '())
        (index  1)]

    ;; Make sure we've cleared the index from previous times
    (for-each node (graph-vertices graph) (.<! node :index nil))

    (letrec [(strong-connect (lambda (v)
                               ;; Setup this vertex, and push it to the stack
                               (.<! v :index index)
                               (.<! v :low-link index)
                               (.<! v :on-stack true)
                               (inc! index)
                               (push! stack v)

                               ;; Look at all successors of v
                               (for-pairs (w _) (vertex-out-edges v)
                                 (cond
                                   ;; Successor w has not been visited, so recuse on it
                                   [(= (.> w :index) nil)
                                    (strong-connect w)
                                    (.<! v :low-link (math/min (.> v :low-link) (.> w :low-link)))]
                                   ;; Successor w is on the stack and so forms a loop
                                   [(.> w :on-stack)
                                    (.<! v :low-link (math/min (.> v :low-link) (.> w :index)))]
                                   [else]))

                               ;; If v is a root node then form an SCC
                               (when (= (.> v :index) (.> v :low-link))
                                 (with (scc '())
                                   (loop [] []
                                     (with (w (pop-last! stack))
                                       (.<! w :on-stack false)
                                       (push! scc w)
                                       (when (/= v w) (recur))))
                                   (push! result scc)))))]

      (for-each node (graph-vertices graph)
        (when (= (.> node :index) nil) (strong-connect node)))

      result)))

(defun condensation (in-graph)
  "Compute the condensation of an input graph, IN-GRAPH, replacing all strongly connected
   components with a super vertex.

   ### Example:
   ```cl
   > (define g (make-graph))
   > (let [(a (add-vertex! g :a))
   .       (b (add-vertex! g :b))
   .       (c (add-vertex! g :c))]
   .   (add-edge! a b)
   .   (add-edge! b a)
   .   (add-edge! a c))
   > (condensation g)
   out = «graph: \"c\" (\"b\" \"a\")»
   ```"
  (assert-type! in-graph graph)

  (let* [(out-graph (make-graph))
         (groups (strongly-connected-components in-graph))]

    (for-each group groups
      (if (and (= (n group) 1) (= (.> (vertex-out-edges (car group)) (car group)) nil))
        (add-vertex! out-graph (vertex-value (car group)))
        (with (vertex (add-vertex! out-graph (map vertex-value group)))
          (for-each old-ver group
            (.<! (graph-vertex-lookup out-graph) (vertex-value old-ver) vertex))))

      (for-each from group
        (for-pairs (to _) (vertex-out-edges from)
          (add-edge! (.> (graph-vertex-lookup out-graph) (vertex-value from))
                     (.> (graph-vertex-lookup out-graph) (vertex-value to))))))

    out-graph))

(defun traverse-preorder (root visitor)
  "Visit a graph using preorder traversal starting at ROOT, calling
   VISITOR for each vertex.

   VISITOR should take the form `(lambda (vertex visited))`, where
   `vertex` is the current vertex and `visited` is a set of already
   visited nodes.

   Whilst the vertices are traversed in order, edges may be traversed in
   a different order for semantically identical graphs. This is
   especially prevalent when the graph contains cycles.

   Note that each vertex will be visited exactly ONCE.

   ### Example:
   ```cl
   > (define g (make-graph))
   > (let [(a (add-vertex! g :a))
   .       (b (add-vertex! g :b))
   .       (c (add-vertex! g :c))]
   .   (add-edge! a b)
   .   (add-edge! b c)
   .   (traverse-preorder a (compose print! pretty)))
   «vertex: \"a\"»
   «vertex: \"b\"»
   «vertex: \"c\"»
   out = nil
   ```"
  (assert-type! root vertex)
  (with (visited {})
    (loop [(node root)] []
      (unless (.> visited node)
        (.<! visited node true)
        (visitor node visited)
        (for-pairs (next) (vertex-out-edges node) (recur next))))))


(defun traverse-postorder (root visitor)
  "Visit a graph using postorder traversal starting at ROOT, calling
   VISITOR for each vertex.

   VISITOR should take the form `(lambda (vertex visited))`, where
   `vertex` is the current vertex and `visited` is a set of already
   visited nodes.

   Whilst the vertices are traversed in order, edges may be traversed in
   a different order for semantically identical graphs. This is
   especially prevalent when the graph contains cycles.

   Note that each vertex will be visited exactly ONCE.

   ### Example:
   ```cl
   > (define g (make-graph))
   > (let [(a (add-vertex! g :a))
   .       (b (add-vertex! g :b))
   .       (c (add-vertex! g :c))]
   .   (add-edge! a b)
   .   (add-edge! b c)
   .   (traverse-postorder a (compose print! pretty)))
   «vertex: \"c\"»
   «vertex: \"b\"»
   «vertex: \"a\"»
   out = nil
   ```"
  (assert-type! root vertex)
  (with (visited {})
    (loop [(node root)] []
      (unless (.> visited node)
        (.<! visited node true)
        (for-pairs (next) (vertex-out-edges node) (recur next))
        (visitor node visited)))))

(defun dominators (root)
  "Build the dominators from nodes descended from ROOT.

   This uses an adaptation of \"A Simple, Fast Dominance Algorithm\" by
   Keith D. Cooper, Timothy J. Harvey and Ken Kennedy. It does not
   compute post order numbers, as this is designed to be generalised for
   cyclic graphs.

   This returns two objects: a lookup of vertex to its immediate dominator,
   and a DAG with edges from dominators to their immediate children.

   ### Example:
   ```cl
   > (define g (make-graph))
   > (define doms
   .   (let [(a (add-vertex! g :a))
   .         (b (add-vertex! g :b))
   .         (c (add-vertex! g :c))
   .         (d (add-vertex! g :d))]
   .     (add-edge! a b)
   .     (add-edge! a c)
   .     (add-edge! b c)
   .     (add-edge! c b)
   .     (add-edge! b d)
   .
   .     (dominators a)))
   > (.> doms (get-vertex g :b))
   out = «vertex: \"a\"»
   > (.> doms (get-vertex g :c))
   out = «vertex: \"a\"»
   > (.> doms (get-vertex g :d))
   out = «vertex: \"b\"»
   ```"
  (assert-type! root vertex)
  (let* [(vertices '())
         (dominators {})
         (dom-graph  (make-graph))]

    ;; Setup the initial dominator state
    (traverse-preorder root
      (lambda (vertex)
        (push! vertices vertex)
        (add-vertex! dom-graph (vertex-value vertex))))

    (.<! dominators root root)

    ;; Loop until we've finished
    (loop [] []
      (with (changed false)
        (traverse-preorder root
          (lambda (vertex visited)
            (unless (= vertex root)
              (with (new-idom nil)
                ;; Attempt to find a vertex which has already been visited (and thus has an immediate
                ;; dominator).
                (for-pairs (prev) (vertex-in-edges vertex)
                  (when (and (= new-idom nil) (/= prev vertex) (.> visited prev))
                    (set! new-idom prev)))
                (when (= new-idom nil) (error! "new-idom is nil"))

                (for-pairs (prev) (vertex-in-edges vertex)
                  (when (and (/= prev new-idom) (/= (.> dominators prev) nil))
                    (set! new-idom (find-common-dominator dominators prev new-idom))))

                (when (/= new-idom (.> dominators vertex))
                  (.<! dominators vertex new-idom)
                  (set! changed true))))))

        (when changed (recur))))

    ;; Clear the root node's dominator, as it doesn't make sense to have one.
    (.<! dominators root nil)

    ;; Compute the dominator graph
    (for-each vertex vertices
      (when-with (dom (.> dominators vertex))
        (add-edge! (get-vertex dom-graph (vertex-value dom)) (get-vertex dom-graph (vertex-value vertex)))))

    (values-list dominators dom-graph)))

(defun find-common-dominator (dominators x y)
  "Find the common dominator for X and Y."
  :hidden
  (with (path {})
    (loop
      [(x x)]
      [(or (= x nil) (.> path x))]
      (.<! path x true)
      (recur (.> dominators x)))

    (loop
      [(y y)]
      [(= y nil) (error! "No common dominator found")]
      (if (.> path y)
        y
        (recur (.> dominators y))))))
