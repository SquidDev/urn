local utf8 = utf8 or {}
return {
	["char"] =        { tag = "var", contents = "utf8.char",        value = utf8.char,        pure = true, },
	["charpattern"] = { tag = "var", contents = "utf8.charpattern", value = utf8.charpattern, pure = true, },
	["codepoint"] =   { tag = "var", contents = "utf8.codepoint",   value = utf8.codepoint,   pure = true, },
	["codes"] =       { tag = "var", contents = "utf8.codes",       value = utf8.codes,       pure = true, },
	["len"] =         { tag = "var", contents = "utf8.len",         value = utf8.len,         pure = true, },
	["offset"] =      { tag = "var", contents = "utf8.offset",      value = utf8.offset,      pure = true, },
}
