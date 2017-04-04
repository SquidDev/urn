local _compiler = _compiler or {}
return {
	["add-categoriser!"] =    { tag = "var", contents = "_compiler[\"add-categoriser!\"]",    value = _compiler["add-categoriser!"],    },
	["add-emitter!"] =        { tag = "var", contents = "_compiler[\"add-emitter!\"]",        value = _compiler["add-emitter!"],        },
	["cat"] =                 { tag = "var", contents = "_compiler.cat",                      value = _compiler.cat,                    },
	["categorise-node"] =     { tag = "var", contents = "_compiler[\"categorise-node\"]",     value = _compiler["categorise-node"],     },
	["categorise-nodes"] =    { tag = "var", contents = "_compiler[\"categorise-nodes\"]",    value = _compiler["categorise-nodes"],    },
	["emit-block"] =          { tag = "var", contents = "_compiler[\"emit-block\"]",          value = _compiler["emit-block"],          },
	["emit-node"] =           { tag = "var", contents = "_compiler[\"emit-node\"]",           value = _compiler["emit-node"],           },
	["writer/append!"] =      { tag = "var", contents = "_compiler[\"writer/append!\"]",      value = _compiler["writer/append!"],      },
	["writer/begin-block!"] = { tag = "var", contents = "_compiler[\"writer/begin-block!\"]", value = _compiler["writer/begin-block!"], },
	["writer/end-block!"] =   { tag = "var", contents = "_compiler[\"writer/end-block!\"]",   value = _compiler["writer/end-block!"],   },
	["writer/indent!"] =      { tag = "var", contents = "_compiler[\"writer/indent!\"]",      value = _compiler["writer/indent!"],      },
	["writer/line!"] =        { tag = "var", contents = "_compiler[\"writer/line!\"]",        value = _compiler["writer/line!"],        },
	["writer/next-block!"] =  { tag = "var", contents = "_compiler[\"writer/next-block!\"]",  value = _compiler["writer/next-block!"],  },
	["writer/unindent!"] =    { tag = "var", contents = "_compiler[\"writer/unindent!\"]",    value = _compiler["writer/unindent!"],    },
}
