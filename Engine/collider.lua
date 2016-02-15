local Physics = require "Engine/physics"

local Collider = {}
function Collider.New(object, type, shape, arg1, arg2)
  local self = setmetatable({Object=object}, {__index=Collider})

  --Body
  self.Body = love.physics.newBody(Physics.World, object.X, object.Y, type)

  --Shape
  if shape == "box" then 
  	self.Shape = love.physics.newRectangleShape(arg1 or 1, arg2 or 1) 
  end

  --Attach body to shape and store object for collision callbacks
  self.Fixture = love.physics.newFixture(self.Body, self.Shape, 1)
  self.Fixture:setUserData(object)
  
  return self
end

function Collider:Draw()
  love.graphics.polygon("line", self.Body:getWorldPoints(self.Shape:getPoints()))
end

function Collider:Sync(dt)
  --Sync if physics system active
  if not Physics.Active then return end

  local obj = self.Object

  --Add linear velocity to object
  local velX, velY = self:GetLinearVelocity()
  obj.X = obj.X + velX * dt
  obj.Y = obj.Y + velY * dt

  --Add angular velocity to object
  obj.Angle = obj.Angle + self:GetAngularVelocity()
end

function Collider:GetPosition()
  return self.Body:getPosition()
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