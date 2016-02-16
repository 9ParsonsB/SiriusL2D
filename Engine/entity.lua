Class("Entity")

Entity.X = 0
Entity.Y = 0
Entity.Angle = 0

function Entity:Sync()
  if self.Collider then
  	--Sync collider with entity
  	self.X, self.Y = self.Collider:GetPosition()
  	self.Angle = self.Collider:GetAngle()
  end
end

function Entity:Face(x, y) 
  self.Angle = (180 / math.pi) * math.atan2(y - self.Y, x - self.X) 
  if self.Collider then self.Collider:SetAngle(self.Angle) end
end

function Entity:SetCollider(type, shape, arg1, arg2) 
  self.Collider = NewObject("Collider", self, type, shape, arg1, arg2)
end

function Entity:GetLinearVelocity()
  if self.Collider then return self.Collider:GetLinearVelocity() end
  return 0, 0
end

function Entity:SetLinearVelocity(x, y)
  if self.Collider then self.Collider:SetLinearVelocity(x, y) end
end