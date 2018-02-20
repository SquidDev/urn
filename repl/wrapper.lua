local window = js.global
local document = window.document
local storage = window.localStorage

-- Copy the file set to a Lua table
local files = {}
local _, tree = ...
for _, file in ipairs(tree.tree) do
  if file.type == "blob" then
    files[file.path] = file.sha
  end
end

local main_thread

-- Setup a series of hooks for input + output
local status = document:getElementById("terminal-status")
local output = document:getElementById("terminal-output")
local input = document:getElementById("terminal-input")
local container = document:getElementById("terminal-container")

-- We provide a small status bar to make it easier to see what's going on
local function set_status(str) status.innerText = str end

local history, history_index = {}, nil

-- Terminal writing + ANSI support
local bold, fg = false, nil
local colours = {
  --      Black              Red                Green              Yellow
  [0x0] = "#2e3436", [0x1] = "#cc0000", [0x2] = "#4e9a06", [0x3] = "#c4a000",
  --       Blue              Magenta            Cyan               White
  [0x4] = "#3464a4", [0x5] = "#af00af", [0x6] = "#06989a", [0x7] = "#d3d7cf",

  [0x8] = "#949494", [0x9] = "#5f87d7", [0xA] = "#8ae234", [0xB] = "#34e2e2",
  [0xC] = "#ef2929", [0xD] = "#ad7fa8", [0xE] = "#ff9d3a", [0xF] = "#ffffff",
}

local function bolden_colour(colour)
  if bold and colour < 8 then return colour + 8 else return colour end
end

--- Scroll to the bottom position
local function scroll()
  container.scrollTop = container.scrollHeight
end

local function append_plain(str)
  if str == "" then return end
  local contents = document:createElement("span")
  contents:appendChild(document:createTextNode(str))
  contents.style.color = colours[bolden_colour(fg or 0x7)]

  output:insertBefore(contents, input)
end

local function append_ansi(str)
  if str == "" then return end

  local pos = 1
  while pos <= #str do
    local esc = str:find("\27%[", pos)
    if esc then
      append_plain(str:sub(pos, esc - 1))

      local args = { "" }
      for off = esc + 2, #str do
        local char = str:sub(off, off)
        if char == "m" then
          for i = 1, #args do
            local arg = tonumber(args[i])
            if arg == 0 then
              bold, fg = false, nil
            elseif arg == 1 then
              bold = true
            elseif arg >= 30 and arg <= 37 then
              fg = arg - 30
            elseif arg >= 90 and arg <= 97 then
              fg = arg - 90 + 8
            end
          end

          pos = off + 1
          break
        elseif char == ";" then
          args[#args + 1] = ""
        elseif char >= "0" and char <= "9" then
          args[#args] = args[#args] .. char
        else
          break
        end
      end
    else
      append_plain(str:sub(pos))
      break
    end
  end
end

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

  local sha = files[path]
  if not sha then return native_open(path, mode) end

  if sha and storage:getItem("file_sha:" .. path) == sha then
    return string_stream(storage:getItem("file_contents:" .. path))
  end

  if coroutine.running() ~= main_thread then
    error("Cannot open file off main coroutine", 2)
  end

  local xhr = js.new(window.XMLHttpRequest)
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
  xhr:open("GET", "https://raw.githubusercontent.com/SquidDev/urn/master/" .. path, true)
  xhr:send()

  while true do
    local kind, ok, res = coroutine.yield()
    if kind == "xhr" then
      if ok then
        storage:setItem("file_sha:" .. path, sha)
        storage:setItem("file_contents:" .. path, res)
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
  scroll()
end

print = function(...)
  local out = table.pack(...)
  for i = 1, out.n do out[i] = tostring(out[i]) end
  append_ansi(table.concat(out, "\t") .. "\n")
  scroll()
end

local function set_input(text)
  input.innerText = text
  input:focus()

  local range = document:createRange()
  range:selectNodeContents(input)
  range:collapse(false)

  local selection = window:getSelection()
  selection:removeAllRanges()
  selection:addRange(range)
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

input.onkeydown = function(self, e)
  if not e then e = window.event end

  local key = e.key or e.which
  if key == "Enter" and not e.shiftKey then
    local value = self.innerText

    -- Clear & blur input
    e:preventDefault()
    self.innerText = ""
    self:blur()

    -- Display input and resume
    history_index = nil
    if value:find("%S") and value ~= history[#history] then
      history[#history + 1] = value
    end

    append_plain(value .. "\n")
    scroll()
    coroutine.resume(main_thread, "input", value)
  elseif key == "ArrowUp" or key == "Up" then
    e:preventDefault()

    if history_index and history_index > 1 then
      history_index = history_index - 1
    elseif not history_index and #history > 0 then
      history_index = #history
    else
      return
    end

    set_input(history[history_index])
  elseif key == "ArrowDown" or key == "Down" then
    e:preventDefault()

    if history_index and history_index < #history then
      history_index = history_index + 1
    elseif history_index then
      history_index = nil
    else
      return
    end

    set_input(history[history_index] or "")
  end
end

input.onpaste = function(self, e)
  if not e then e = window.event end
  e:preventDefault()

  local text = e.clipboardData:getData("text/plain")
  document:execCommand("insertHTML", false, text)
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
        window.console:log(err)
        window.console:log(debug.traceback(tostring(err), 2))
    end)
end)

assert(coroutine.resume(main_thread))
