local _compiler = _compiler or {}
return {
	["add-pass!"] = { tag = "var", contents = "_compiler[\"add-pass!\"]", value = _compiler["add-pass!"], },
	["var-usage"] = { tag = "var", contents = "_compiler[\"var-usage\"]", value = _compiler["var-usage"], },
}
