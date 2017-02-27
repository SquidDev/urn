local os = os or {}
return {
	["clock"] =     { tag = "var", contents = "os.clock",     value = os.clock,     },
	["date"] =      { tag = "var", contents = "os.date",      value = os.date,      },
	["difftime"] =  { tag = "var", contents = "os.difftime",  value = os.difftime,  },
	["execute"] =   { tag = "var", contents = "os.execute",   value = os.execute,   },
	["exit"] =      { tag = "var", contents = "os.exit",      value = os.exit,      },
	["getenv"] =    { tag = "var", contents = "os.getenv",    value = os.getenv,    },
	["remove"] =    { tag = "var", contents = "os.remove",    value = os.remove,    },
	["rename"] =    { tag = "var", contents = "os.rename",    value = os.rename,    },
	["setlocale"] = { tag = "var", contents = "os.setlocale", value = os.setlocale, },
	["time"] =      { tag = "var", contents = "os.time",      value = os.time,      },
	["tmpname"] =   { tag = "var", contents = "os.tmpname",   value = os.tmpname,   },
}
