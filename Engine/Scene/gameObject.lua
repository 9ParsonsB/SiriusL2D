local Transform = require "Engine/Scene/transform"
local GameObject = Class("GameObject", Transforms)

GameObject.Active = true

--Default animation info
GameObject.Frame = 1
GameObject.Timer = 0
GameObject.State = "idle"
GameObject.Loop = true

--Default physics info
GameObject.UsePhysics = false
GameObject.Type = "dynamic"
GameObject.Shape = "box"

--Default object size
GameObject.Width = 16
GameObject.Height = 16

--Type checking
function GameObject:IsType(name)
  if self.Name == name then return true end
  if self.Parent then return self.Parent:IsType(name) end
  return false
end

function GameObject:MouseOver()
  return self:Contains(Camera:GetMousePosition())
end

function GameObject:Contains(a, b)
  local x, y = self.X - (self.Width / 2), self.Y - (self.Height / 2)
  return a >= x and a <= x + self.Width and b >= y and b <= y + self.Height
end

--Teleport to location(Ignores physics)
function GameObject:Teleport(x, y)
  local collider = Physics.Colliders[self]
  if collider then collider:SetPosition(x, y) end
  self.X, self.Y = x, y
end

--Get velocity(If there is a collider)
function GameObject:GetVelocity(x, y)
  local collider = Physics.Colliders[self]
  if collider then return collider:GetLinearVelocity(x, y) end
  return 0, 0
end

--Set velocity(If there is a collider)
function GameObject:SetVelocity(x, y)
  local collider = Physics.Colliders[self]
  if collider then collider:SetLinearVelocity(x, y) end
end

--Set animation to play
function GameObject:PlayAnimation(state)
  self.State = state
  self.Frame = 1
  self.Timer = 0
end

--Game loop functions
function GameObject:Create() end
function GameObject:Update(dt) end
function GameObject:Ui() end

function GameObject:Draw() end

function GameObject:CollisionEnter(object, coll) end
function GameObject:CollisionExit(object, coll) end

function GameObject:KeyPressed(key) end
function GameObject:KeyReleased(key) end

function GameObject:MousePressed(x, y, button, isTouch) end
function GameObject:MouseReleased(x, y, button, isTouch) end
function GameObject:MouseMoved(x, y, dx, dy) end
function GameObject:WheelMoved(x, y) end

local Objects = {}

function Object(name, parent)
  local self = Class(name, parent or GameObject)
  Objects[name] = self
  Script.Env[name] = self
  return self
end

function Instance(name, x, y, angle)
  if not Objects[name] then error(name .. " not defined") end
  local self = setmetatable({X=x or 0, Y=y or 0, Angle=angle or 0}, {__index=Objects[name]}) 
  Scene.Add(self)
  self:Create() 
  return self
end
return GameObject