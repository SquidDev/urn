return {
	['='] =  { tag = "expr", contents = "(${1} == ${2})", count = 2, pure = true },
	['/='] = { tag = "expr", contents = "(${1} ~= ${2})", count = 2, pure = true },
	['<']  = { tag = "expr", contents = "(${1} < ${2})",  count = 2, pure = true },
	['<='] = { tag = "expr", contents = "(${1} <= ${2})", count = 2, pure = true },
	['>']  = { tag = "expr", contents = "(${1} > ${2})",  count = 2, pure = true },
	['>='] = { tag = "expr", contents = "(${1} >= ${2})", count = 2, pure = true },

	['+']  = { tag = "expr", contents = "(${1} + ${2})",  count = 2, pure = true },
	['-']  = { tag = "expr", contents = "(${1} - ${2})",  count = 2, pure = true },
	['*']  = { tag = "expr", contents = "(${1} * ${2})",  count = 2, pure = true },
	['/']  = { tag = "expr", contents = "(${1} / ${2})",  count = 2, pure = true },
	['%']  = { tag = "expr", contents = "(${1} % ${2})",  count = 2, pure = true },
	['^']  = { tag = "expr", contents = "(${1} ^ ${2})",  count = 2, pure = true },
	['..'] = { tag = "expr", contents = "(${1} .. ${2})", count = 2, pure = true },

	-- This is basically a crime.
	-- * Feb 20th, 2017: no longer a crime!
	['get-idx'] = { tag = "expr", contents = "${1}[${2}]" , count = 2 },
	['set-idx!'] = { tag = "stmt", contents = "${1}[${2}] = ${3}", count = 3 },
}
