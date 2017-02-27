return {
	['='] =  { tag = "expr", contents = "(${1} == ${2})", count = 2, pure = true, value = function(x, y) return x == y end },
	['/='] = { tag = "expr", contents = "(${1} ~= ${2})", count = 2, pure = true, value = function(x, y) return x ~= y end },
	['<']  = { tag = "expr", contents = "(${1} < ${2})",  count = 2, pure = true, value = function(x, y) return x < y end  },
	['<='] = { tag = "expr", contents = "(${1} <= ${2})", count = 2, pure = true, value = function(x, y) return x <= y end },
	['>']  = { tag = "expr", contents = "(${1} > ${2})",  count = 2, pure = true, value = function(x, y) return x > y end  },
	['>='] = { tag = "expr", contents = "(${1} >= ${2})", count = 2, pure = true, value = function(x, y) return x >= y end },

	['+']  = { tag = "expr", contents = "(${1} + ${2})",  count = 2, pure = true, value = function(x, y) return x + y end  },
	['-']  = { tag = "expr", contents = "(${1} - ${2})",  count = 2, pure = true, value = function(x, y) return x - y end  },
	['*']  = { tag = "expr", contents = "(${1} * ${2})",  count = 2, pure = true, value = function(x, y) return x * y end  },
	['/']  = { tag = "expr", contents = "(${1} / ${2})",  count = 2, pure = true, value = function(x, y) return x / y end  },
	['%']  = { tag = "expr", contents = "(${1} % ${2})",  count = 2, pure = true, value = function(x, y) return x % y end  },
	['^']  = { tag = "expr", contents = "(${1} ^ ${2})",  count = 2, pure = true, value = function(x, y) return x ^ y end  },
	['..'] = { tag = "expr", contents = "(${1} .. ${2})", count = 2, pure = true, value = function(x, y) return x .. y end },

	['get-idx']  = { tag = "expr", contents = "${1}[${2}]",        count = 2, value = function(x, k) return x[k] end },
	['set-idx!'] = { tag = "stmt", contents = "${1}[${2}] = ${3}", count = 3, value = function(x, k, v) x[k] = v end },
}
