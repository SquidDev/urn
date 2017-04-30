local optimise = _compiler or {}
return {
	["fusion/add-rule!"] = { tag = "var", contents = "_compiler[\"fusion/add-rule!\"]", value = optimise["fusion/add-rule!"], },
}
