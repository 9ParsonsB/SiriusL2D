require "Engine/Common/vector"

local Transform = Class("Transform")

Transform.X, Transform.Y = 0, 0
Transform.LastX, Transform.LastY = 0, 0
Transform.Angle = 0
Transform.LastAngle = 0

function Transform:Attach(object) 
  object.Parent = self 
end

--Teleport to location(Ignores physics)
function Transform:Teleport(x, y)
  local collider = Physics.Colliders[self]
  if collider then collider:SetPosition(x, y) end
  self.X, self.Y = x, y
end

--Get velocity(If there is a collider)
function Transform:GetVelocity(x, y)
  local collider = Physics.Colliders[self]
  if collider then return collider:GetLinearVelocity(x, y) end
  return 0, 0
end

--Set velocity(If there is a collider)
function Transform:SetVelocity(x, y)
  local collider = Physics.Colliders[self]
  if collider then collider:SetLinearVelocity(x, y) end
end

function Transform:MoveTo(x, y)
	
end
return Transform