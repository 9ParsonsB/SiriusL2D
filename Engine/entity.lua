Entity = Class("Entity")

Entity.X = 0
Entity.Y = 0
Entity.Angle = 0

--Virtual functions
function Entity:Update(dt) end
function Entity:Draw() end
function Entity:KeyPressed(key) end
function Entity:KeyReleased(key) end
function Entity:MousePressed(x, y, button, isTouch) end
function Entity:MouseReleased(x, y, button) end

function Entity:SetPosition(x, y)
  x, y = x or 0, y or 0
  if self.Collider then self.Collider:SetPosition(x, y) end--self.Collider:Move(x - self.X, y - self.Y) end
  self.X, self.Y = x, y
end

function Entity:SetSprite(texture, width, height)
  self.Sprite = Renderer.Sprite(texture, width, height)
end

function Entity:SetCollider(type, shape, arg1, arg2)
  self.Collider = Physics.Collider(self, type, shape, arg1, arg2)
end

function Entity:SetFixedRotation(rotation)
  if self.Collider then self.Collider:SetFixedRotation(rotation) end
end

function Entity:GetRestitution()
  if self.Collider then return self.Collider:GetRestitution() end
end

function Entity:SetRestitution(restitution)
  if self.Collider then self.Collider:SetRestitution(restitution) end
end

function Entity:GetLinearVelocity()
  if self.Collider then return self.Collider:GetLinearVelocity() end
  return 0,0
end

function Entity:SetLinearVelocity(x, y)
  if self.Collider then return self.Collider:SetLinearVelocity(x, y) end
end