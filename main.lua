local Script = require "Engine/script"

function love.load()
  love.graphics.setBackgroundColor(104, 136, 248)
  love.physics.setMeter(64)
  World = love.physics.newWorld(0, 5*64, true)
  World:setCallbacks(beginContact, endContact)
  
  local Player = Script.Load("Game/player")
  test = Player(200, 200)
end

function love.update(dt)
  test:Update(dt)
  World:update(dt)
end

function love.draw()
  test:Draw()
end

--Physics callbacks
function beginContact(a, b, coll)
  local self = a:getUserData()
  local other = b:getUserData()
   if self and other then
      if type(self.CollisionEnter) == "function" then self:CollisionEnter(other, coll) end
      if type(other.CollisionEnter) == "function" then other:CollisionEnter(self, coll) end
  end
end

function endContact(a, b, coll)
  local self = a:getUserData()
  local other = b:getUserData()

  local bodyA = a:getBody()
  local bodyB = b:getBody()

  if self and other then
      self.X = bodyA:getX()
      self.Y = bodyA:getY()
      --self.Angle = (180 / math.pi) * bodyA:getAngle()
      self:SetLinearVelocity(bodyA:getLinearVelocity())
      --self:SetAngularVelocity(bodyA:getAngularVelocity())
        
      if type(self.CollisionExit) == "function" then self:CollisionExit(other, coll) end
      if type(other.CollisionExit) == "function" then other:CollisionExit(self, coll) end
  end
end