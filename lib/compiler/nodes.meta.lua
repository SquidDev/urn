local _compiler = _compiler or {}
return {
	["builtin?"] =       { tag = "var", contents = "_compiler[\"builtin?\"]",       value = _compiler["builtin?"],       },
	["builtin"] =        { tag = "var", contents = "_compiler[\"builtin\"]",        value = _compiler["builtin"],        },
	["constant?"] =      { tag = "var", contents = "_compiler[\"constant?\"]",      value = _compiler["constant?"],      },
	["node->val"] =      { tag = "var", contents = "_compiler[\"node->val\"]",      value = _compiler["node->val"],      },
	["symbol->var"] =    { tag = "var", contents = "_compiler[\"symbol->var\"]",    value = _compiler["symbol->var"],    },
	["traverse-node"] =  { tag = "var", contents = "_compiler[\"traverse-node\"]",  value = _compiler["traverse-node"],  },
	["traverse-nodes"] = { tag = "var", contents = "_compiler[\"traverse-nodes\"]", value = _compiler["traverse-nodes"], },
	["val->node"] =      { tag = "var", contents = "_compiler[\"val->node\"]",      value = _compiler["val->node"],      },
	["var->symbol"] =    { tag = "var", contents = "_compiler[\"var->symbol\"]",    value = _compiler["var->symbol"],    },
	["visit-node"] =     { tag = "var", contents = "_compiler[\"visit-node\"]",     value = _compiler["visit-node"],     },
	["visit-nodes"] =    { tag = "var", contents = "_compiler[\"visit-nodes\"]",    value = _compiler["visit-nodes"],    },
}
