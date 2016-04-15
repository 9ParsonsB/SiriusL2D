require "Engine/Common/vector"

local Transform = Class("Transform")

Transform.Position = Vector()
Transform.Angle = 0

function Transform:Attach(object) 
  object.Parent = self 
end

function Transform:Interpoll(position, rate)
  
end

--Teleport to location(Ignores physics)
function Transform:Teleport(x, y)
  local collider = Physics.Colliders[self]
  if collider then collider:SetPosition(x, y) end
  self.Position = Vector(x, y)
  self.LastPosition = Vector(x, y)
end

--Get velocity(If there is a collider)
function Transform:GetLinearVelocity(x, y)
  local collider = Physics.Colliders[self]
  if collider then return collider:GetLinearVelocity(x, y) end
  return 0, 0
end

--Set velocity(If there is a collider)
function Transform:SetLinearVelocity(x, y)
  local collider = Physics.Colliders[self]
  if collider then collider:SetLinearVelocity(x, y) end
end
return Transform