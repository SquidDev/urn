-- A horrible hacky script to ensure that package.path is correct
local directory = arg[0]:gsub("urn/cli%.lisp", ""):gsub("urn/cli$", ""):gsub("tacky/cli%.lua$", "")
if directory ~= "" and directory:sub(-1, -1) ~= "/" then
	directory = directory .. "/"
end

package.path = package.path .. package.config:sub(3, 3) .. directory .. "?.lua"
return {}
