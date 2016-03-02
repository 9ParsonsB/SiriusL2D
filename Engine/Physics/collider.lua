local Collider = Class("Collider")

function Collider:Create(object, type, shape, arg1, arg2)
  self.Body = love.physics.newBody(Physics.World, object.X, object.Y, type)

  --arg1-Width arg2-Height
  if shape == "box" then
    local width, height = arg1 or 1, arg2 or 1
    self.Shape = love.physics.newRectangleShape(width / 2, height / 2) 
  end

  --arg1-Radius
  if shape == "circle" then
    local radius = arg1 or 1
    self.Shape = love.physics.newCircleShape(radius)
  end

  --Attach body to shape and store object for collision callbacks
  self.Fixture = love.physics.newFixture(self.Body, self.Shape, 1)
  self.Fixture:setUserData(object)
end

function Collider:Draw()
  if not Physics.Debug then return end
  love.graphics.polygon("line", self.Body:getWorldPoints(self.Shape:getPoints()))
end

function Collider:Move(amountX, amountY)
  local x, y = self:GetPosition()
  self:SetPosition(x + amountX, y + amountY)
end

--Getters/setters

function Collider:GetX()
  return self.Body:getX()
end

function Collider:GetY()
  return self.Body:getY()
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