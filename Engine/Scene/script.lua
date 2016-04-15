local Scripts = {}
local ModTimes = {}

Script = {
  LiveEdit = true,
  Env = setmetatable({}, {__index = _G})
}

function Script.Reload()
  for k,v in pairs(ModTimes) do
    local modTime = love.filesystem.getLastModified(k .. ".lua")
    if modTime ~= v then Script.Load(k) end
  end
end

function Script.Load(filePath)
  local chunk = love.filesystem.load(filePath .. ".lua")
  setfenv(chunk, Script.Env)
  chunk()

  ModTimes[filePath] = love.filesystem.getLastModified(filePath .. ".lua")

  return env
end