local State = require "Engine/state"
local Physics = require "Engine/physics"
local Collider = require "Engine/collider"
local Renderer = require "Engine/renderer"

local Object = {Classes={}, Directory=""}

local env = setmetatable({}, {__index=_G})
env.State = State
env.Physics = Physics

function Object.load(name, filePath)
  local self = {Name = name}
  self.Chunk = love.filesystem.load(Object.Directory .. filePath)
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

  function self.Include(name)
    local class = Object.Classes[name]
    if class then 
      setfenv(class.Chunk, self)
      class.Chunk()
      if type(self.Create) == "function" then self.Create() end
    end
  end

  --Default object functions
  function self.SetCollider(type, shape, arg1, arg2)
    self.Collider = Collider.New(self, type, shape, arg1, arg2)
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
    if self.Collider then self.Collider:SetAngle(self.Angle) end
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