return {
	['='] = { tag = "expr", contents = "(${1} == ${2})", count = 2 },
	['/='] = { tag = "expr", contents = "(${1} ~= ${2})", count = 2 },
	['<']  = { tag = "expr", contents = "(${1} < ${2})",  count = 2 },
	['<='] = { tag = "expr", contents = "(${1} <= ${2})", count = 2 },
	['>']  = { tag = "expr", contents = "(${1} > ${2})",  count = 2 },
	['>='] = { tag = "expr", contents = "(${1} >= ${2})", count = 2 },

	['+']  = { tag = "expr", contents = "(${1} + ${2})",  count = 2 },
	['-']  = { tag = "expr", contents = "(${1} - ${2})",  count = 2 },
	['*']  = { tag = "expr", contents = "(${1} * ${2})",  count = 2 },
	['/']  = { tag = "expr", contents = "(${1} / ${2})",  count = 2 },
	['%']  = { tag = "expr", contents = "(${1} % ${2})",  count = 2 },
	['^']  = { tag = "expr", contents = "(${1} ^ ${2})",  count = 2 },
	['..'] = { tag = "expr", contents = "(${1} .. ${2})", count = 2 },

	-- This is basically a crime.
	['rawget'] = { tag = "expr", contents = "${1}[${2}]" , count = 2 },
	['rawset'] = { tag = "stmt", contents = "${1}[${2}] = ${3}", count = 3 },
}
