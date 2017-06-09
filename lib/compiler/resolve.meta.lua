local _compiler = _compiler or {}
return {
	["active-node"] =    { tag = "var", contents = "_compiler[\"active-node\"]",    value = _compiler["active-node"],    },
	["active-scope"] =   { tag = "var", contents = "_compiler[\"active-scope\"]",   value = _compiler["active-scope"],   },
	["active-module"] =  { tag = "var", contents = "_compiler[\"active-module\"]",  value = _compiler["active-module"],  },
	["scope-vars"] =     { tag = "var", contents = "_compiler[\"scope-vars\"]",     value = _compiler["scope-vars"],     },
	["var-definition"] = { tag = "var", contents = "_compiler[\"var-definition\"]", value = _compiler["var-definition"], },
	["var-docstring"] =  { tag = "var", contents = "_compiler[\"var-docstring\"]",  value = _compiler["var-docstring"],  },
	["var-lookup"] =     { tag = "var", contents = "_compiler[\"var-lookup\"]",     value = _compiler["var-lookup"],     },
	["try-var-lookup"] = { tag = "var", contents = "_compiler[\"try-var-lookup\"]", value = _compiler["try-var-lookup"], },
	["var-value"] =      { tag = "var", contents = "_compiler[\"var-value\"]",      value = _compiler["var-value"],      },
}
