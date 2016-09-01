local Collider = Class("Collider")

function Collider:Create(object)
  self.Body = love.physics.newBody(Physics.World, object.Position.X, object.Position.Y, object.Type or "dynamic")
  self.Object = object

  --Create objects shape
  if object.Shape == "box" then self.Shape = love.physics.newRectangleShape(object.Width or 1, object.Height or 1) end
  if object.Shape == "circle" then self.Shape = love.physics.newCircleShape(object.Radius or 1) end

  --Attach body to shape and store object for collision callbacks
  self.Fixture = love.physics.newFixture(self.Body, self.Shape, 1)
  self.Fixture:setUserData(self)

  --Set properties  
  self:SetRestitution(object.Restitution or 0)
  self.Body:setFixedRotation(object.FixedRotation or false)

  --Store collider
  Physics.Colliders[object] = self
end

function Collider:Destroy()
  self.Body:destroy()
  Physics.Colliders[self.Object] = nil
end

function Collider:GetDistance(dt)
  local position = Vector(self:GetPosition())
  return (self.Object.Position - position) / dt
end

function Collider:GetAngleDistance(dt)
  return (self.Object.Angle - self:GetAngle()) / dt
end

function Collider:BeginSync(dt)
  --Get distances
  self.Distance = self:GetDistance(dt)
  self.DistAngle = self:GetAngleDistance(dt)

  --Add velocity offset
  local x, y = self:GetLinearVelocity()
  local angle = self:GetAngularVelocity()

  self:SetLinearVelocity(x + self.Distance.X, y + self.Distance.Y)
  self:SetAngularVelocity(angle + self.DistAngle)
end

function Collider:EndSync(dt)
  --Remove velocity offset
  local x, y = self:GetLinearVelocity()
  local angle = self:GetAngularVelocity()

  self:SetLinearVelocity(x - self.Distance.X, y - self.Distance.Y)
  self:SetAngularVelocity(angle - self.DistAngle)

  --Update position and angle of object
  self.Object.Position = Vector(self:GetPosition())
  self.Object.Angle = self:GetAngle()
end

function Collider:Draw()
  if not Physics.Debug then return end

  --Draw outline of collider
  local shape = self.Shape:getType()
  if shape == "polygon" then 
    love.graphics.polygon("line", self.Body:getWorldPoints(self.Shape:getPoints()))
  elseif shape == "circle" then
    love.graphics.circle("line", self.Object.Position.X, self.Object.Position.Y, self.Object.Radius)
  end
end

function Collider:GetPosition()
  local x, y = self.Body:getPosition()
  return x, y
end

function Collider:SetPosition(x, y)
  self.Body:setPosition(x, y)
end

function Collider:GetAngle()
  return math.deg(self.Body:getAngle())
end

function Collider:SetAngle(degrees)
  self.Body:setAngle((math.pi / 180) * degrees)
end

function Collider:GetLinearVelocity()
  return self.Body:getLinearVelocity()
end

function Collider:SetLinearVelocity(x, y)
  self.Body:setLinearVelocity(x, y)
end

function Collider:GetAngularVelocity()
 return self.Body:getAngularVelocity()
end

function Collider:SetAngularVelocity(angle)
 self.Body:setAngularVelocity(angle)
end

function Collider:GetRestitution()
  return self.Fixture:getRestitution()
end

function Collider:SetRestitution(restitution)
  self.Fixture:setRestitution(restitution)
end

function Collider:GetFriction()
  return self.Body:getFriction()
end

function Collider:SetFriction(friction)
  self.Body:setFriction(friction)
end

function Collider:GetLinearDamping()
  return self.Body:getLinearDamping()
end

function Collider:SetLinearDamping(damping)
  self.Body:setLinearDamping(damping)
end
return Collider