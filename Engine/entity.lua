local Entity = Class("Entity", {X = 0, Y = 0, Angle = 0})

function Entity:init()
  self.Attached = {}
  self.Count = 0
end

function Entity:Sync()
  --Sync collider with entity
  if self.Collider then
  	self.X, self.Y = self.Collider:GetPosition()
  	self.Angle = self.Collider:GetAngle()
  end
end

function Entity:Attach(object)
  self.Attached[self.Count] = object
  self.Count = self.Count + 1
end

function Entity:GetPosition()
  return self.X, self.Y
end
function Entity:SetPosition(x, y)
  self.X, self.Y = x or self.X, y or self.Y
  
  if self.Collider then 
    self.Collider:SetPosition(x, y) 
  end
end

function Entity:GetAngleTo(x, y) 
  return (180 / math.pi) * math.atan2(y - self.Y, x - self.X) 
end

function Entity:SetCollider(type, shape, arg1, arg2) 
  self.Collider = NewObject("Collider", self, type, shape, arg1, arg2)
end

function Entity:SetSensor(sensor)
  if self.Collider then self.Collider.Fixture:setSensor(sensor) end
end

function Entity:GetLinearVelocity()
  if self.Collider then return self.Collider:GetLinearVelocity() end
  return 0, 0
end
function Entity:SetLinearVelocity(x, y)
  if self.Collider then self.Collider:SetLinearVelocity(x, y) end
end

function Entity:GetAngularVelocity()
  return self.Collider:GetAngularVelocity()
end
function Entity:SetAngularVelocity(velocity)
  self.Collider:SetAngularVelocity(velocity)
end
return Entity