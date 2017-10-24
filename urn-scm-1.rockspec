package = "urn"
version = "scm-1"
source = {
	url = "git+https://gitlab.com/urn/urn.git"
}
description = {
	summary = "A Lisp dialect which compiles to Lua.",
	detailed = [[
Urn is a minimalistic Lisp dialect which compiles to Lua, focusing
on generating ideomatic, mostly-readable code. It has a comprehensive
standard library, a powerful compiler and more.
]],
	homepage = "http://urn-lang.com",
	license = "BSD-3-Clause",
}
dependencies = {
	"lua >= 5.1, < 5.4",
}
build = {
	type = "builtin",
	modules = {},
	install = {
		bin = {
			urn = "bin/urn.lua",
		},
	},
	copy_directories = {
		"docs",
		"plugins",
		"tests",
		"urn-lib",
	},
}
