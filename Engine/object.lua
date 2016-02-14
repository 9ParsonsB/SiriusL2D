local State = require "Engine/state"
local Physics = require "Engine/physics"
local Collider = require "Engine/collider"
local Renderer = require "Engine/renderer"

local Object = {Classes={}}

local env = setmetatable({}, {__index=_G})
env.State = State

function Object.load(name, filePath)
  local self = {Name = name}
  self.Chunk = love.filesystem.load(filePath)
  Object.Classes[name] = self
end

function Object.new(object, x, y)
  local self = {
    X = x or 0, 
    Y = y or 0, 
    Angle = 0, 
  }
  self.self = self
  setmetatable(self, {__index=env})

  --Default object functions
  function self.SetCollider(cInfo)
    self.Collider = Collider.New(self, Physics.World, cInfo)
  end

  function self.GetLinearVelocity(x, y)
    if self.Collider then return self.Collider:GetLinearVelocity() end
    return 0, 0
  end
  function self.SetLinearVelocity(x, y)
    if self.Collider then self.Collider:SetLinearVelocity(x, y) end
  end

  function self.DrawCollider()
    if self.Collider then self.Collider:Draw() end
  end

  function self.Face(x, y) 
    self.Angle = (180 / math.pi) * math.atan2(y - self.Y, x - self.X) 
  end

  function self.DrawSprite(texture, x, y, angle, width, height)
    Renderer.DrawSprite(texture, x, y, angle, width, height)
  end

  --Custom object definition
  setfenv(object.Chunk, self)
  object.Chunk()

  --Create callback
  if type(self.Create) == "function" then self.Create() end
  return self
end

function Object.create(self, name, x, y)
  return Object.new(Object.Classes[name], x, y)
end
return setmetatable(Object, {__call=Object.create})