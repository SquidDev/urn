(import compiler/nodes compiler)
(import compiler/pass ())
(import compiler/resolve compiler)

(import io)
(import data/graph ())

(defmethod (pretty var)     (var) (.> var :full-name))

(defpass generate-dependency-graph (state nodes)
  "Emit an out.dot file, tracking the dependencies between functions."
  :cat '("warn")
  (with (graph (make-graph))
    (for-each node nodes
      (when-with (var (.> node :def-var))
        (add-vertex! graph var)))

    (for-each node nodes
      (when-with (var (.> node :def-var))
        (with (from (get-vertex graph var))
          (compiler/visit-node node
            (lambda (x)
              (when (symbol? x)
                (when-with (to (get-vertex graph (.> x :var)))
                  (add-edge! from to))))))))

    (io/write-all! "out.dot" (graph->dot graph))))

,(add-pass! generate-dependency-graph)
