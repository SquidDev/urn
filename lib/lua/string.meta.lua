local string = string or {}
return {
	["byte"] =    { tag = "var", contents = "string.byte",    value = string.byte,    },
	["char"] =    { tag = "var", contents = "string.char",    value = string.char,    },
	["dump"] =    { tag = "var", contents = "string.dump",    value = string.dump,    },
	["find"] =    { tag = "var", contents = "string.find",    value = string.find,    },
	["format"] =  { tag = "var", contents = "string.format",  value = string.format,  },
	["gsub"] =    { tag = "var", contents = "string.gsub",    value = string.gsub,    },
	["len"] =     { tag = "var", contents = "string.len",     value = string.len,     },
	["lower"] =   { tag = "var", contents = "string.lower",   value = string.lower,   },
	["match"] =   { tag = "var", contents = "string.match",   value = string.match,   },
	["rep"] =     { tag = "var", contents = "string.rep",     value = string.rep,     },
	["reverse"] = { tag = "var", contents = "string.reverse", value = string.reverse, },
	["sub"] =     { tag = "var", contents = "string.sub",     value = string.sub,     },
	["upper"] =   { tag = "var", contents = "string.upper",   value = string.upper,   },
}
