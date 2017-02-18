return {
  getmetatable = getmetatable,
  setmetatable = setmetatable,
  ['iter-pairs'] = function(tbl, fun) for k, v in pairs(tbl) do fun(k, v) end end, -- TODO: Migrate to Urn somehow
  next = next,
}
