local Collider = {}

function Collider.New(object, world, t)
  local self = setmetatable({Object=object}, {__index=Collider})

  --Location
  local x = object.X + (t.X or 0)
  local y = object.Y + (t.y or 0)

  --Store offsets for syncing with object
  self.OffsetX = t.X or 0
  self.OffsetY = t.Y or 0
  self.OffsetAngle = t.Angle or 0

  --Body and shape
  self.Body = love.physics.newBody(world, x, y, t.Type)
  if t.Shape == "box" then 
  	self.Shape = love.physics.newRectangleShape(t.Width or 1, t.Height or 1) 
  end

  --Attach body to shape and store object for collision callbacks
  self.Fixture = love.physics.newFixture(self.Body, self.Shape, t.Density or 1)
  self.Fixture:setUserData(object)

  return self
end

function Collider:Draw()
  love.graphics.polygon("line", self.Body:getWorldPoints(self.Shape:getPoints()))
end

function Collider:Sync(dt)
  local obj = self.Object
  local velX, velY = self:GetLinearVelocity()
  obj.X = obj.X + velX * dt
  obj.Y = obj.Y + velY * dt
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
return Collider