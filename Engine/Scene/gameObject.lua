local GameObject = Class("GameObject")

GameObject.Active = true

--Default transform info
GameObject.X, GameObject.Y = 0, 0
GameObject.Angle = 0
GameObject.LastX, GameObject.LastY = 0, 0
GameObject.LastAngle = 0

--Default animation info
GameObject.Frame = 1
GameObject.Timer = 0
GameObject.State = "idle"
GameObject.Loop = true

function GameObject:Attach(object) 
  object.Parent = self 
end

function GameObject:Teleport(x, y)
  local collider = Physics.Colliders[self]
  if collider then collider:SetPosition(x, y) end
  self.X, self.Y = x, y
end

function GameObject:GetVelocity(x, y)
  local collider = Physics.Colliders[self]
  if collider then return collider:GetLinearVelocity(x, y) end
  return 0, 0
end

function GameObject:SetVelocity(x, y)
  local collider = Physics.Colliders[self]
  if collider then collider:SetLinearVelocity(x, y) end
end

function GameObject:PlayAnimation(state)
  self.State = state
  self.Frame = 1
  self.Timer = 0
end

--Game loop methods
function GameObject:Create() end
function GameObject:Update(dt) end
function GameObject:Ui() end
function GameObject:CollisionEnter(object, coll) end
function GameObject:CollisionExit(object, coll) end
function GameObject:KeyPressed(key) end
function GameObject:KeyReleased(key) end

local Objects = {}

function Object(name, parent)
  local self = Objects[name] or setmetatable({}, {__index=parent or GameObject})
  for k,v in pairs(self) do self[k] = nil end

  self.Name = name
  self.Parent = parent

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