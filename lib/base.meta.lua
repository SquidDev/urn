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

	['empty-struct'] = { tag = "expr", contents = "{}", count = 0 },

	-- So *technically* we use rawget, but it shouldn't actually matter.
	['get-idx'] = { tag = "expr", contents = "${1}[${2}]" , count = 2 },
	['set-idx!'] = { tag = "stmt", contents = "${1}[${2}] = ${3}", count = 3 },
}
