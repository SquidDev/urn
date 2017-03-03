local ffi = require 'ffi'

return {
	["C"] =        { tag = "var", contents = "require('ffi').C",        value = ffi.C,        },
	["abi"] =      { tag = "var", contents = "require('ffi').abi",      value = ffi.abi,      },
	["alignof"] =  { tag = "var", contents = "require('ffi').alignof",  value = ffi.alignof,  },
	["arch"] =     { tag = "var", contents = "require('ffi').arch",     value = ffi.arch,     },
	["cast"] =     { tag = "var", contents = "require('ffi').cast",     value = ffi.cast,     },
	["cdef"] =     { tag = "var", contents = "require('ffi').cdef",     value = ffi.cdef,     },
	["copy"] =     { tag = "var", contents = "require('ffi').copy",     value = ffi.copy,     },
	["errno"] =    { tag = "var", contents = "require('ffi').errno",    value = ffi.errno,    },
	["fill"] =     { tag = "var", contents = "require('ffi').fill",     value = ffi.fill,     },
	["gc"] =       { tag = "var", contents = "require('ffi').gc",       value = ffi.gc,       },
	["istype"] =   { tag = "var", contents = "require('ffi').istype",   value = ffi.istype,   },
	["load"] =     { tag = "var", contents = "require('ffi').load",     value = ffi.load,     },
	["metatype"] = { tag = "var", contents = "require('ffi').metatype", value = ffi.metatype, },
	["new"] =      { tag = "var", contents = "require('ffi').new",      value = ffi.new,      },
	["offsetof"] = { tag = "var", contents = "require('ffi').offsetof", value = ffi.offsetof, },
	["os"] =       { tag = "var", contents = "require('ffi').os",       value = ffi.os,       },
	["sizeof"] =   { tag = "var", contents = "require('ffi').sizeof",   value = ffi.sizeof,   },
	["string"] =   { tag = "var", contents = "require('ffi').string",   value = ffi.string,   },
	["typeinfo"] = { tag = "var", contents = "require('ffi').typeinfo", value = ffi.typeinfo, },
	["typeof"] =   { tag = "var", contents = "require('ffi').typeof",   value = ffi.typeof,   },
}
