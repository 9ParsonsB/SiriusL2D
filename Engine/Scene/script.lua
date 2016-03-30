local Scripts = {}
local ModTimes = {}

local Env = setmetatable({}, {__index = _G})
function Env.Class(name, parent)
  local class = Class(name, parent)
  class.X, class.Y = 0, 0
  class.VelX, class.VelY = 0, 0
  Env[name] = class
end

Script = {
  Dir = "Scripts/",
  LiveEdit = true,
}

function Script.Reload()
  for k,v in pairs(ModTimes) do
    local modTime = love.filesystem.getLastModified(Script.Dir .. k .. ".lua")
    if modTime ~= v then Script.Load(k) end
  end
end

function Script.Load(filePath)
  local chunk = love.filesystem.load(Script.Dir .. filePath .. ".lua")
  setfenv(chunk, Env)
  chunk()

  ModTimes[filePath] = love.filesystem.getLastModified(Script.Dir .. filePath .. ".lua")

  return env
end