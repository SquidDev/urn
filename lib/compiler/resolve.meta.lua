local _compiler = _compiler or {}
return {
	["active-node"] =    { tag = "var", contents = "_compiler[\"active-node\"]",    value = _compiler["active-node"],    },
	["active-scope"] =   { tag = "var", contents = "_compiler[\"active-scope\"]",   value = _compiler["active-scope"],   },
	["var-definition"] = { tag = "var", contents = "_compiler[\"var-definition\"]", value = _compiler["var-definition"], },
	["var-docstring"] =  { tag = "var", contents = "_compiler[\"var-docstring\"]",  value = _compiler["var-docstring"],  },
	["var-lookup"] =     { tag = "var", contents = "_compiler[\"var-lookup\"]",     value = _compiler["var-lookup"],     },
	["var-value"] =      { tag = "var", contents = "_compiler[\"var-value\"]",      value = _compiler["var-value"],      },
}
