local _compiler = _compiler or {}
return {
	["logger/do-node-error!"] =    { tag = "var", contents = "_compiler[\"logger/do-node-error!\"]",    value = _compiler["logger/do-node-error!"],    },
	["logger/put-debug!"] =        { tag = "var", contents = "_compiler[\"logger/put-debug!\"]",        value = _compiler["logger/put-debug!"],        },
	["logger/put-error!"] =        { tag = "var", contents = "_compiler[\"logger/put-error!\"]",        value = _compiler["logger/put-error!"],        },
	["logger/put-node-error!"] =   { tag = "var", contents = "_compiler[\"logger/put-node-error!\"]",   value = _compiler["logger/put-node-error!"],   },
	["logger/put-node-warning!"] = { tag = "var", contents = "_compiler[\"logger/put-node-warning!\"]", value = _compiler["logger/put-node-warning!"], },
	["logger/put-verbose!"] =      { tag = "var", contents = "_compiler[\"logger/put-verbose!\"]",      value = _compiler["logger/put-verbose!"],      },
	["logger/put-warning!"] =      { tag = "var", contents = "_compiler[\"logger/put-warning!\"]",      value = _compiler["logger/put-warning!"],      },
}
