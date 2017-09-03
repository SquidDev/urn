local nodes = _compiler or {}
return {
	["builtin"] =             { tag = "var", contents = "_compiler.builtin",                  value = nodes.builtin,                },
	["builtin?"] =            { tag = "var", contents = "_compiler[\"builtin?\"]",            value = nodes["builtin?"],            },
	["constant?"] =           { tag = "var", contents = "_compiler[\"constant?\"]",           value = nodes["constant?"],           },
	["node->val"] =           { tag = "var", contents = "_compiler[\"node->val\"]",           value = nodes["node->val"],           },
	["node-contains-var?"] =  { tag = "var", contents = "_compiler[\"node-contains-var?\"]",  value = nodes["node-contains-var?"],  },
	["node-contains-vars?"] = { tag = "var", contents = "_compiler[\"node-contains-vars?\"]", value = nodes["node-contains-vars?"], },
	["symbol->var"] =         { tag = "var", contents = "_compiler[\"symbol->var\"]",         value = nodes["symbol->var"],         },
	["traverse-node"] =       { tag = "var", contents = "_compiler[\"traverse-node\"]",       value = nodes["traverse-node"],       },
	["traverse-nodes"] =      { tag = "var", contents = "_compiler[\"traverse-nodes\"]",      value = nodes["traverse-nodes"],      },
	["val->node"] =           { tag = "var", contents = "_compiler[\"val->node\"]",           value = nodes["val->node"],           },
	["var->symbol"] =         { tag = "var", contents = "_compiler[\"var->symbol\"]",         value = nodes["var->symbol"],         },
	["visit-node"] =          { tag = "var", contents = "_compiler[\"visit-node\"]",          value = nodes["visit-node"],          },
	["visit-nodes"] =         { tag = "var", contents = "_compiler[\"visit-nodes\"]",         value = nodes["visit-nodes"],         },
}
