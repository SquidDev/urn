local compiler = _compiler or {}
return {
	["flag?"] =                    { tag = "var", contents = "_compiler[\"flag?\"]",                    value = compiler["flag?"],                    },
	["flags"] =                    { tag = "var", contents = "_compiler.flags",                         value = compiler.flags,                       },
	["logger/do-node-error!"] =    { tag = "var", contents = "_compiler[\"logger/do-node-error!\"]",    value = compiler["logger/do-node-error!"],    },
	["logger/put-debug!"] =        { tag = "var", contents = "_compiler[\"logger/put-debug!\"]",        value = compiler["logger/put-debug!"],        },
	["logger/put-error!"] =        { tag = "var", contents = "_compiler[\"logger/put-error!\"]",        value = compiler["logger/put-error!"],        },
	["logger/put-node-error!"] =   { tag = "var", contents = "_compiler[\"logger/put-node-error!\"]",   value = compiler["logger/put-node-error!"],   },
	["logger/put-node-warning!"] = { tag = "var", contents = "_compiler[\"logger/put-node-warning!\"]", value = compiler["logger/put-node-warning!"], },
	["logger/put-verbose!"] =      { tag = "var", contents = "_compiler[\"logger/put-verbose!\"]",      value = compiler["logger/put-verbose!"],      },
	["logger/put-warning!"] =      { tag = "var", contents = "_compiler[\"logger/put-warning!\"]",      value = compiler["logger/put-warning!"],      },
	["range/get-source"] =         { tag = "var", contents = "_compiler[\"range/get-source\"]",         value = compiler["range/get-source"],         },
}
