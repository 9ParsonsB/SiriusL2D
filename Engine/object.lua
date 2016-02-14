local Physics = require "Engine/physics"
local Collider = require "Engine/collider"
local Renderer = require "Engine/renderer"

local Object = {Classes={}}

function Object.define(object, name)
  local self = {Name = name, includes = {}, count = 0}
  Object.Classes[name] = self
  return setmetatable(self, {__index = Object, __call = Object.new})
end

function Object.new(class, x, y)
  local self = {
    X = x or 0, 
    Y = y or 0, 
    Angle = 0, 
  }
  setmetatable(self, {__index=_G})

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

  --Custom object functions
  for k, v in pairs(class.includes) do
    setfenv(v, self)
    v()
  end
  if type(self.Create) == "function" then self.Create() end
  return self
end

function Object.create(name, x, y)
  return Object.new(Object.Classes[name], x, y)
end

function Object:include(filePath)
  local chunk = love.filesystem.load(filePath)
  self.includes[self.count] = chunk
  self.count = self.count + 1
end
return setmetatable(Object, {__call=Object.define})