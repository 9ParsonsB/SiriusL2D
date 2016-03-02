local Entity = require "Engine/Scene/entity"

--[[Creating objects:
1. LoadFile(filePath)
2. Create(chunk, x, y)--]]

--Entity currently being loaded
local self = Entity()

--Enviroment for loading entities
--Redirects functions to self
local env = setmetatable({}, {__index=_G})
function env.SetCollider(type, shape, arg1, arg2)
 self:SetCollider(type, shape, arg1, arg2)
end
function env.SetSprite(texture, x, y, angle)
  self:SetSprite(texture, x, y, angle)
end
function env.AddScript(script, ...)
  self:AddScript(script, ...)
end

--Loads a entity from a file
local Entities = {}
function Create(chunk, x, y)
  --Create entity
  self = Entity()
  self:SetPosition(x or 0, y or 0)

  --Load entity
  setfenv(chunk, env)
  chunk()
  Scene.Add(self)

  return self
end

function LoadEntity(filePath)
  --Prevent loading the same file twice
  if Entities[filePath] then return Entities[filePath] end

  --Load entity
  local chunk = love.filesystem.load(filePath .. ".lua")

  --Store entity
  Entities[filePath] = chunk

  return chunk
end