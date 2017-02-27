local io = io or {}
return {
	["close"] =   { tag = "var", contents = "io.close",   value = io.close,   },
	["flush"] =   { tag = "var", contents = "io.flush",   value = io.flush,   },
	["input"] =   { tag = "var", contents = "io.input",   value = io.input,   },
	["lines"] =   { tag = "var", contents = "io.lines",   value = io.lines,   },
	["open"] =    { tag = "var", contents = "io.open",    value = io.open,    },
	["output"] =  { tag = "var", contents = "io.output",  value = io.output,  },
	["popen"] =   { tag = "var", contents = "io.popen",   value = io.popen,   },
	["read"] =    { tag = "var", contents = "io.read",    value = io.read,    },
	["stderr"] =  { tag = "var", contents = "io.stderr",  value = io.stderr,  },
	["stdin"] =   { tag = "var", contents = "io.stdin",   value = io.stdin,   },
	["stdout"] =  { tag = "var", contents = "io.stdout",  value = io.stdout,  },
	["tmpfile"] = { tag = "var", contents = "io.tmpfile", value = io.tmpfile, },
	["type"] =    { tag = "var", contents = "io.type",    value = io.type,    },
	["write"] =   { tag = "var", contents = "io.write",   value = io.write,   },
}
