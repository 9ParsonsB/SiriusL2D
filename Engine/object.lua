local Entity = require "Engine/entity"

local Objects = {}
local FileInfo = {}

Object = {}

function Object.Update(dt)
  for k,v in pairs(FileInfo) do
    local modtime = love.filesystem.getLastModified(k .. ".lua")
    if modtime ~= v then Object.Load(k) end
  end
end

function Object.Get(name)
  return Objects[name] or {}
end

function Object.Load(filePath)
  local env = setmetatable({}, {__index=_G})

  --Load file
  local chunk = love.filesystem.load(filePath .. ".lua")
  setfenv(chunk, env)
  chunk()

  --Store object
  local name = filePath:match("([^/]+)$")
  Objects[name] = object
  FileInfo[filePath] = love.filesystem.getLastModified(filePath .. ".lua")
end 

function Instance(name, x, y)
  return Entity(name, x, y)
end