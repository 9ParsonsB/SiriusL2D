local Scripts = {}
local ModTimes = {}

Script = {
  Dir = "Scripts/",
  LiveEdit = true,
  Env = setmetatable({}, {__index = _G})
}

function Script.Reload()
  for k,v in pairs(ModTimes) do
    local modTime = love.filesystem.getLastModified(Script.Dir .. k .. ".lua")
    if modTime ~= v then Script.Load(k) end
  end
end

function Script.Load(filePath)
  local chunk = love.filesystem.load(Script.Dir .. filePath .. ".lua")
  setfenv(chunk, Script.Env)
  chunk()

  ModTimes[filePath] = love.filesystem.getLastModified(Script.Dir .. filePath .. ".lua")

  return env
end