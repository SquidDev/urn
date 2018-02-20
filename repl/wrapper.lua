local worker = js.global

-- Copy the file set to a Lua table
local _, tree = ...
local file_hashes, file_cache = {}, {}
local tree_hash = tree.sha
for _, file in ipairs(tree.tree) do
  if file.type == "blob" then
    file_hashes[file.path] = file.sha
  end
end

local main_thread

-- Wrappers for various methods
local function set_status(str) worker.messages:status(str) end
local function append_ansi(str) worker.messages:write_ansi(str) end
local function set_input(str) worker.messages:prompt(str) end

-- Remove blocking http loaders
table.remove(package.searchers, 6)
table.remove(package.searchers, 5)

-- Override the basic IO functions
local function string_stream(str)
  return {
    read = function() return str end,
    close = function() end,
  }
end

local native_open = io.open
io.open = function(path, mode)
  if mode and mode ~= "r" then return native_open(path, mode) end

  local hash = file_hashes[path]
  if not hash then return native_open(path, mode) end

  local contents = file_cache[path]
  if contents then return contents end

  if coroutine.running() ~= main_thread then
    error("Cannot open file off main coroutine", 2)
  end

  local xhr = js.new(worker.XMLHttpRequest)
  xhr.onreadystatechange = function()
    if xhr.readyState == 4 then
      if xhr.status == 200 then
        set_status("Downloaded " .. path)
        coroutine.resume(main_thread, "xhr", true, xhr.responseText)
      else
        set_status("Error downloading " .. path)
        coroutine.resume(main_thread, "xhr", false, "Cannot find " .. path)
      end
    end
  end

  set_status("Downloading " .. path)
  xhr:open("GET", "https://cdn.rawgit.com/SquidDev/urn/" .. tree_hash .. "/" .. path, true)
  xhr:send()

  while true do
    local kind, ok, res = coroutine.yield()
    if kind == "xhr" then
      if ok then
        file_cache[path] = res
        return string_stream(res)
      else
        return nil, res
      end
    end
  end
end

io.write = function(...)
  local out = table.pack(...)
  for i = 1, out.n do out[i] = tostring(out[i]) end
  append_ansi(table.concat(out))
end

print = function(...)
  local out = table.pack(...)
  for i = 1, out.n do out[i] = tostring(out[i]) end
  append_ansi(table.concat(out, "\t") .. "\n")
end

io.read = function(...)
  if coroutine.running() ~= main_thread then
    error("Cannot open file off main coroutine", 2)
  end

  set_input("")
  while true do
    local kind, res = coroutine.yield()
    if kind == "input" then return res end
  end
end

package.loaded["urn.readline"] = function(prompt, initial, complete)
  if coroutine.running() ~= main_thread then
    error("Cannot read text off main coroutine", 2)
  end

  append_ansi(prompt)
  set_input(initial)
  while true do
    local kind, res = coroutine.yield()
    if kind == "input" then return res end
  end
end

worker.onmessage = function(self, e)
  if e.data.tag == "input" then
    coroutine.resume(main_thread, "input", e.data.input)
  else
    worker.console.error("Unknown message", e)
  end
end

main_thread = coroutine.create(function()
    xpcall(
      function()
        local handle, err = io.open("bin/urn.lua")
        if not handle then error(err, 0) end

        local contents = handle:read():gsub("^#![^\n]*", "")
        handle:close()

        set_status("Running Urn REPL")
        return assert(load(contents, "@bin/urn.lua"))()
      end,
      function(err)
        worker.console:log(err)
        worker.console:log(debug.traceback(tostring(err), 2))
    end)
end)

local ok, err = coroutine.resume(main_thread)
if not ok then worker.console:log(err) end
