(import compiler/optimise (fusion/defrule))

;; (not (/= x y)) => (= x y)
(fusion/defrule (not (/= ?x ?y))
                (= ?x ?y))
(fusion/defrule (cond [(/= ?x ?y) false] [true true])
                (= ?x ?y))

;; (not (= x y)) => (/= x y)
(fusion/defrule (not (= ?x ?y))
                (/= ?x ?y))
(fusion/defrule (cond [(= ?x ?y) false] [true true])
                (/= ?x ?y))

;; (unless (= x y) z) => (when (/= x y) z
;; It'd be nice to have z match 0..n statements, but the system doesn't
;; support that yet.
(fusion/defrule (cond [(= ?x ?y)] [true ?z])
                (cond [(/= ?x ?y) ?z] [true]))

;; (unless (/= x y) z) => (when (= x y) z
(fusion/defrule (cond [(/= ?x ?y)] [true ?z])
                (cond [(= ?x ?y) ?z] [true]))
