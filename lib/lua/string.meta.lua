local string = string or {}
return {
	["byte"] =    { tag = "var", contents = "string.byte",    value = string.byte,    pure = true, },
	["char"] =    { tag = "var", contents = "string.char",    value = string.char,    pure = true, },
	["dump"] =    { tag = "var", contents = "string.dump",    value = string.dump,    pure = true, },
	["find"] =    { tag = "var", contents = "string.find",    value = string.find,    pure = true, },
	["format"] =  { tag = "var", contents = "string.format",  value = string.format,  pure = true, },
	["gsub"] =    { tag = "var", contents = "string.gsub",    value = string.gsub,    pure = true, },
	["len"] =     { tag = "var", contents = "string.len",     value = string.len,     pure = true, },
	["lower"] =   { tag = "var", contents = "string.lower",   value = string.lower,   pure = true, },
	["match"] =   { tag = "var", contents = "string.match",   value = string.match,   pure = true, },
	["rep"] =     { tag = "var", contents = "string.rep",     value = string.rep,     pure = true, },
	["reverse"] = { tag = "var", contents = "string.reverse", value = string.reverse, pure = true, },
	["sub"] =     { tag = "var", contents = "string.sub",     value = string.sub,     pure = true, },
	["upper"] =   { tag = "var", contents = "string.upper",   value = string.upper,   pure = true, },
}
