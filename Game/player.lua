local Speed = 3000

Class("Player", "Entity")

function Player:init()
  self.X, self.Y = 200, 200
  self:SetCollider("dynamic", "box", 16, 16)
  self.Collider:SetLinearDamping(4)
  Engine.Add(self, "Game")
end

function Player:Update(dt)
  if not Physics.Active then return end

  --Camera follows player
  Engine.Camera.X = self.X - (love.graphics.getWidth() / 2) + 8
  Engine.Camera.Y = self.Y - (love.graphics.getHeight() / 2) + 8

  local angle = self:GetAngleTo(Engine.Camera:GetMousePosition())
  self:SetAngularVelocity((angle - self.Angle))

  --WASD movement controls
  local x, y = self:GetLinearVelocity()
  if love.keyboard.isDown("w") then y = y - Speed * dt end
  if love.keyboard.isDown("a") then x = x - Speed * dt end
  if love.keyboard.isDown("s") then y = y + Speed * dt end
  if love.keyboard.isDown("d") then x = x + Speed * dt end
  self:SetLinearVelocity(x, y)
end

function Player:Draw()
  Renderer.DrawSprite("greenRect.png", self.X, self.Y, self.Angle)
  self.Collider:Draw()
end