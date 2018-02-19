(define-native =
  "Determine if two variables are equal."
  :syntax "${1} == ${2}" :syntax-precedence 3 :pure)
(define-native /=
  :syntax "${1} ~= ${2}" :syntax-precedence 3 :pure)
(define-native <
  :syntax "${1} < ${2}"  :syntax-precedence 3 :pure)
(define-native <=
  :syntax "${1} <= ${2}" :syntax-precedence 3 :pure)
(define-native >
  :syntax "${1} > ${2}"  :syntax-precedence 3 :pure)
(define-native >=
  :syntax "${1} >= ${2}" :syntax-precedence 3 :pure)

(define-native +
  :syntax "${1} + ${2}"  :syntax-precedence  9 :pure :syntax-fold "left")
(define-native -
  :syntax "${1} - ${2}"  :syntax-precedence  9 :pure :syntax-fold "left")
(define-native *
  :syntax "${1} * ${2}"  :syntax-precedence 10 :pure :syntax-fold "left")
(define-native /
  :syntax "${1} / ${2}"  :syntax-precedence 10 :pure :syntax-fold "left")
(define-native mod
  :syntax "${1} % ${2}"  :syntax-precedence 10 :pure :syntax-fold "left")
(define-native expt
  :syntax "${1} ^ ${2}"  :syntax-precedence 12 :pure :syntax-fold "right")
(define-native ..
  :syntax "${1} .. ${2}" :syntax-precedence  8 :pure :syntax-fold "right")

(define-native len#
  :syntax "#${1}"        :syntax-precedence 11 :pure)

(define-native get-idx
  :syntax "${1}[${2}]"       :syntax-precedence (100 0))
(define-native set-idx!
  :syntax "${1}[${2}] = ${3}"  :syntax-precedence (100 0 0) :stmt)

(define-native _ENV            :bind-to "_ENV")
(define-native _G              :bind-to "_G")
(define-native arg#            :bind-to "arg or {...}")
(define-native assert          :bind-to "assert")
(define-native collectgarbage  :bind-to "collectgarbage")
(define-native dofile          :bind-to "dofile")
(define-native error           :bind-to "error")
(define-native getmetatable    :bind-to "getmetatable")
(define-native ipairs          :bind-to "ipairs")
(define-native load            :bind-to "load")
(define-native loadfile        :bind-to "loadfile")
(define-native next            :bind-to "next")
(define-native pairs           :bind-to "pairs")
(define-native pcall           :bind-to "pcall")
(define-native print           :bind-to "print")
(define-native rawequal        :bind-to "rawequal"        :pure)
(define-native rawget          :bind-to "rawget")
(define-native rawlen          :bind-to "rawlen")
(define-native rawset          :bind-to "rawset")
(define-native require         :bind-to "require")
(define-native select          :bind-to "select"          :pure)
(define-native setmetatable    :bind-to "setmetatable")
(define-native tonumber        :bind-to "tonumber"        :pure)
(define-native tostring        :bind-to "tostring"        :pure)
(define-native type#           :bind-to "type"            :pure)
(define-native xpcall          :bind-to "xpcall")
