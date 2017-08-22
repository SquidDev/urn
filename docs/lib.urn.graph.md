---
title: urn/graph
---
# urn/graph
Provides an implementation of directed graphs.

This provides basic algorithms for working with graphs, support for
super-vertices, and other nifty features.

## `(add-edge! from to)`
*Defined at lib/urn/graph.lisp:63:1*

Add an edge `FROM` one vertex `TO` another.

## `(add-vertex! graph value)`
*Defined at lib/urn/graph.lisp:44:1*

Create a vertex with the corresponding `VALUE` and add it to the `GRAPH`.

## `(condensation in-graph)`
*Defined at lib/urn/graph.lisp:142:1*

Compute the condensation of an input graph, `IN`-`GRAPH`, replacing all strongly connected
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
out = «graph: "c" ("b" "a")»
```

## `(dominators root)`
*Defined at lib/urn/graph.lisp:248:1*

Build the dominators from nodes descended from `ROOT`.

This uses an adaptation of "`A` Simple, Fast Dominance Algorithm" by
Keith `D`. Cooper, Timothy `J`. Harvey and Ken Kennedy. It does not
compute post order numbers, as this is designed to be generalised for
cyclic graphs.

This returns two objects: a lookup of vertex to its immediate dominator,
and a `DAG` with edges from dominators to their immediate children.

## `(get-vertex graph value)`
*Defined at lib/urn/graph.lisp:55:1*

Get the corresponding vertex for this `VALUE` from the given `GRAPH`.

## `(graph->dot graph name)`
*Defined at lib/urn/graph.lisp:27:1*

Convert `GRAPH` to a string in the `DOT` format, suitable for consumption
with GraphViz.

## `make-graph`
*Defined at lib/urn/graph.lisp:8:1*

Create a new, empty graph.

## `(strongly-connected-components graph)`
*Defined at lib/urn/graph.lisp:75:1*

Find all strong components from a `GRAPH`.

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
out = ((«vertex: "c"») («vertex: "b"» «vertex: "a"»))
```

## `(traverse-postorder root visitor)`
*Defined at lib/urn/graph.lisp:213:1*

Visit a graph using postorder traversal starting at `ROOT`, calling
`VISITOR` for each vertex.

`VISITOR` should take the form `(lambda (vertex visited))`, where
`vertex` is the current vertex and `visited` is a set of already
visited nodes.

Whilst the vertices are traversed in order, edges may be traversed in
a different order for semantically identical graphs. This is
especially prevalent when the graph contains cycles.

Note that each vertex will be visited exactly `ONCE`.

### Example:
```cl
> (define g (make-graph))
> (let [(a (add-vertex! g :a))
.       (b (add-vertex! g :b))
.       (c (add-vertex! g :c))]
.   (add-edge! a b)
.   (add-edge! b c)
.   (traverse-postorder a (compose print! pretty)))
«vertex: "c"»
«vertex: "b"»
«vertex: "a"»
out = nil
```

## `(traverse-preorder root visitor)`
*Defined at lib/urn/graph.lisp:177:1*

Visit a graph using preorder traversal starting at `ROOT`, calling
`VISITOR` for each vertex.

`VISITOR` should take the form `(lambda (vertex visited))`, where
`vertex` is the current vertex and `visited` is a set of already
visited nodes.

Whilst the vertices are traversed in order, edges may be traversed in
a different order for semantically identical graphs. This is
especially prevalent when the graph contains cycles.

Note that each vertex will be visited exactly `ONCE`.

### Example:
```cl
> (define g (make-graph))
> (let [(a (add-vertex! g :a))
.       (b (add-vertex! g :b))
.       (c (add-vertex! g :c))]
.   (add-edge! a b)
.   (add-edge! b c)
.   (traverse-preorder a (compose print! pretty)))
«vertex: "a"»
«vertex: "b"»
«vertex: "c"»
out = nil
```

## Undocumented symbols
 - `$graph` *Defined at lib/urn/graph.lisp:8:1*
 - `$vertex` *Defined at lib/urn/graph.lisp:16:1*
 - `(graph-vertex-lookup r_544)` *Defined at lib/urn/graph.lisp:8:1*
 - `(graph-vertices r_542)` *Defined at lib/urn/graph.lisp:8:1*
 - `(graph? r_541)` *Defined at lib/urn/graph.lisp:8:1*
 - `(vertex? r_551)` *Defined at lib/urn/graph.lisp:16:1*
