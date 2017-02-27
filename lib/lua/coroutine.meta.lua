local coroutine = coroutine or {}
return {
	["create"] =      { tag = "var", contents = "coroutine.create",      value = coroutine.create,      },
	["isyieldable"] = { tag = "var", contents = "coroutine.isyieldable", value = coroutine.isyieldable, },
	["resume"] =      { tag = "var", contents = "coroutine.resume",      value = coroutine.resume,      },
	["running"] =     { tag = "var", contents = "coroutine.running",     value = coroutine.running,     },
	["status"] =      { tag = "var", contents = "coroutine.status",      value = coroutine.status,      },
	["wrap"] =        { tag = "var", contents = "coroutine.wrap",        value = coroutine.wrap,        },
	["yield"] =       { tag = "var", contents = "coroutine.yield",       value = coroutine.yield,       },
}
