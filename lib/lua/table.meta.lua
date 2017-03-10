local table = table or {}
return {
	["concat"] =       { tag = "var", contents = "table.concat",       value = table.concat,       },
	["insert"] =       { tag = "var", contents = "table.insert",       value = table.insert,       },
	["move"] =         { tag = "var", contents = "table.move",         value = table.move,         },
	["pack"] =         { tag = "var", contents = "table.pack",         value = table.pack,         },
	["remove"] =       { tag = "var", contents = "table.remove",       value = table.remove,       },
	["sort"] =         { tag = "var", contents = "table.sort",         value = table.sort,         },
	["unpack"] =       { tag = "var", contents = "table.unpack",       value = table.unpack,       },

	["empty-struct"] = { tag = "expr", contents = "({})", count = 0, value = "function() return {} end" },

	-- OK, it is a little horrible include this.
	["iter-pairs" ] = {
		tag = "var",
		contents = "function(x, f) for k, v in pairs(x) do f(k, v) end end",
		value = function(x, f) for k, v in pairs(x) do f(k, v) end end,
	}
}
