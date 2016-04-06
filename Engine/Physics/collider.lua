local Collider = Class("Collider")

function Collider:Create(object)
  self.Object = object

  self.Body = love.physics.newBody(Physics.World, object.X, object.Y, object.Type or "dynamic")

  --Shape
  if object.Shape == "box" then self.Shape = love.physics.newRectangleShape(object.Width or 1, object.Height or 1) end
  if object.Shape == "circle" then self.Shape = love.physics.newCircleShape(object.Radius or 1) end

  --Attach body to shape and store object for collision callbacks
  self.Fixture = love.physics.newFixture(self.Body, self.Shape, 1)
  self.Fixture:setUserData(self)

  --Set properties  
  self.Fixture:setRestitution(object.Bounciness or 0)
  self.Body:setFixedRotation(object.FixedRotation or false)

  Physics.Colliders[object] = self
end

--Add distance to velocity
function Collider:BeginSync(dt)
  local x, y = self:GetLinearVelocity()
  local angle = self:GetAngularVelocity()

  local distX, distY = self.Object.X - self.Object.LastX, self.Object.Y - self.Object.LastY
  local distAngle = self.Object.Angle - self.Object.LastAngle

  self:SetLinearVelocity(x + (distX / dt), (distY / dt))
  self:SetAngularVelocity(angle + (distAngle / dt))
end

--Remove distance from velocity
function Collider:EndSync(dt)
  local x, y = self:GetLinearVelocity()
  local angle = self:GetAngularVelocity()

  local distX, distY = self.Object.X - self.Object.LastX, self.Object.Y - self.Object.LastY
  local distAngle = self.Object.Angle - self.Object.LastAngle

  self:SetLinearVelocity(x - (distX / dt), (distY / dt))
  self:SetAngularVelocity(angle - (distAngle / dt))

  self.Object.X, self.Object.Y = self:GetPosition()
  self.Object.Angle = self:GetAngle()
end

function Collider:Draw()
  if not Physics.Debug then return end
  love.graphics.polygon("line", self.Body:getWorldPoints(self.Shape:getPoints()))
end

function Collider:GetPosition()
  local x, y = self.Body:getPosition()
  return x, y
end
function Collider:SetPosition(x, y)
  self.Body:setPosition(x, y)
end

function Collider:GetAngle()
  return (180 / math.pi) * self.Body:getAngle()
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