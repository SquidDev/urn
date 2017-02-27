local package = package or {}
return {
	["config"] =     { tag = "var", contents = "package.config",     value = package.config,     },
	["cpath"] =      { tag = "var", contents = "package.cpath",      value = package.cpath,      },
	["loaded"] =     { tag = "var", contents = "package.loaded",     value = package.loaded,     },
	["loadlib"] =    { tag = "var", contents = "package.loadlib",    value = package.loadlib,    },
	["path"] =       { tag = "var", contents = "package.path",       value = package.path,       },
	["preload"] =    { tag = "var", contents = "package.preload",    value = package.preload,    },
	["searchers"] =  { tag = "var", contents = "package.searchers",  value = package.searchers,  },
	["searchpath"] = { tag = "var", contents = "package.searchpath", value = package.searchpath, },
}
