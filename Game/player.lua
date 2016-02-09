local Wall = Script.Load("Game/wall")
local Player = Wall:extend(Wall)

Player.Speed = 300
Player.Screen = "Game"

function Player:init(x, y)
  self.X = x or 0
  self.Y = y or 0
  self.Body = love.physics.newBody(World, x, y, "dynamic")
  self.Body:setFixedRotation(true)
  self.Shape = love.physics.newRectangleShape(16, 16)
  self.Fixture = love.physics.newFixture(self.Body, self.Shape)
  self.Fixture:setUserData(self)
end
function Player:Update(dt)
  local x, y = self.Body:getLinearVelocity()

  --WASD movement
  if love.keyboard.isDown("w") then y = y - self.Speed * 3 * dt end
  if love.keyboard.isDown("s") then y = y + self.Speed * dt end
  if love.keyboard.isDown("a") then x = x - self.Speed * dt end	
  if love.keyboard.isDown("d") then x = x + self.Speed * dt end

  --Update velocity
  self.Body:setLinearVelocity(x, y)

  --Network.SendMsg("Shoot")
end
function Player:Draw()
  Renderer.DrawSprite("greenRect.png", self.Body:getX(), self.Body:getY())
  love.graphics.polygon("line", self.Body:getWorldPoints(self.Shape:getPoints()))
end
function Player:CollisionEnter(other, coll)

end
function Player:CollisionExit(other, coll)

end
function Player:Sync(self, remote)

end
return Player