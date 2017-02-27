local debug = debug or {}
return {
	["debug"] =        { tag = "var", contents = "debug.debug",        value = debug.debug,        },
	["gethook"] =      { tag = "var", contents = "debug.gethook",      value = debug.gethook,      },
	["getinfo"] =      { tag = "var", contents = "debug.getinfo",      value = debug.getinfo,      },
	["getlocal"] =     { tag = "var", contents = "debug.getlocal",     value = debug.getlocal,     },
	["getmetatable"] = { tag = "var", contents = "debug.getmetatable", value = debug.getmetatable, },
	["getregistry"] =  { tag = "var", contents = "debug.getregistry",  value = debug.getregistry,  },
	["getupvalue"] =   { tag = "var", contents = "debug.getupvalue",   value = debug.getupvalue,   },
	["getuservalue"] = { tag = "var", contents = "debug.getuservalue", value = debug.getuservalue, },
	["sethook"] =      { tag = "var", contents = "debug.sethook",      value = debug.sethook,      },
	["setlocal"] =     { tag = "var", contents = "debug.setlocal",     value = debug.setlocal,     },
	["setmetatable"] = { tag = "var", contents = "debug.setmetatable", value = debug.setmetatable, },
	["setupvalue"] =   { tag = "var", contents = "debug.setupvalue",   value = debug.setupvalue,   },
	["setuservalue"] = { tag = "var", contents = "debug.setuservalue", value = debug.setuservalue, },
	["traceback"] =    { tag = "var", contents = "debug.traceback",    value = debug.traceback,    },
	["upvalueid"] =    { tag = "var", contents = "debug.upvalueid",    value = debug.upvalueid,    },
	["upvaluejoin"] =  { tag = "var", contents = "debug.upvaluejoin",  value = debug.upvaluejoin,  },
}
