(import compiler/optimise (fusion/defrule))

(fusion/defrule (map ?f (map ?g ?xs))
                (map (lambda (%x) (?f (?g %x))) ?xs))

(fusion/defrule (filter ?f (filter ?g ?xs))
                (filter (lambda (%x) (cond [(?g %x) (?f %x)] [true false])) ?xs))

(fusion/defrule (reduce ?f ?z (map ?g ?xs))
                (reduce (lambda (%ac %x) (?f %ac (?g %x))) ?z ?xs))
