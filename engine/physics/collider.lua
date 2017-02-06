local Collider = class("Collider")

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
  self:setRestitution(object.Restitution or 0)
  self.Body:setFixedRotation(object.FixedRotation or false)

  --Store collider
  Physics.Colliders[object] = self
end

function Collider:destroy()
  self.Body:destroy()
  Physics.Colliders[self.Object] = nil
end

function Collider:getDistance(dt)
  local position = Vector(self:getPosition())
  return (self.Object.Position - position) / dt
end

function Collider:getAngleDistance(dt)
  return (self.Object.Angle - self:getAngle()) / dt
end

function Collider:beginSync(dt)
  --Get distances
  self.Distance = self:getDistance(dt)
  self.DistAngle = self:getAngleDistance(dt)

  --Add velocity offset
  local x, y = self:getLinearVelocity()
  local angle = self:getAngularVelocity()

  self:setLinearVelocity(x + self.Distance.X, y + self.Distance.Y)
  self:setAngularVelocity(angle + self.DistAngle)
end

function Collider:endSync(dt)
  --Remove velocity offset
  local x, y = self:getLinearVelocity()
  local angle = self:getAngularVelocity()

  self:setLinearVelocity(x - self.Distance.X, y - self.Distance.Y)
  self:setAngularVelocity(angle - self.DistAngle)

  --Update position and angle of object
  self.Object.Position = Vector(self:getPosition())
  self.Object.Angle = self:getAngle()
end

function Collider:draw()
  if not Physics.Debug then return end

  --Draw outline of collider
  local shape = self.Shape:getType()
  if shape == "polygon" then 
    love.graphics.polygon("line", self.Body:getWorldPoints(self.Shape:getPoints()))
  elseif shape == "circle" then
    love.graphics.circle("line", self.Object.Position.X, self.Object.Position.Y, self.Object.Radius)
  end
end

function Collider:getPosition()
  local x, y = self.Body:getPosition()
  return x, y
end

function Collider:setPosition(x, y)
  self.Body:setPosition(x, y)
end

function Collider:getAngle()
  return math.deg(self.Body:getAngle())
end

function Collider:setAngle(degrees)
  self.Body:setAngle((math.pi / 180) * degrees)
end

function Collider:getLinearVelocity()
  return self.Body:getLinearVelocity()
end

function Collider:setLinearVelocity(x, y)
  self.Body:setLinearVelocity(x, y)
end

function Collider:getAngularVelocity()
 return self.Body:getAngularVelocity()
end

function Collider:setAngularVelocity(angle)
 self.Body:setAngularVelocity(angle)
end

function Collider:getRestitution()
  return self.Fixture:getRestitution()
end

function Collider:setRestitution(restitution)
  self.Fixture:setRestitution(restitution)
end

function Collider:getFriction()
  return self.Body:getFriction()
end

function Collider:setFriction(friction)
  self.Body:setFriction(friction)
end

function Collider:getLinearDamping()
  return self.Body:getLinearDamping()
end

function Collider:setLinearDamping(damping)
  self.Body:setLinearDamping(damping)
end
return Collider