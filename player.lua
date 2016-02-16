Speed = 500

Class("Player", "Entity")

function Player:Create()
  self.X, self.Y = 200, 200
  self:SetCollider("dynamic", "box", 16, 16)
  self.Collider:SetLinearDamping(4)
  State.Add(self, "Game")
end

function Player:Update(dt)
  --Camera follows player
  local camera = State.GetCamera("Game")
  camera.X = self.X - (love.graphics.getWidth() / 2) + 8
  camera.Y = self.Y - (love.graphics.getHeight() / 2) + 8

  --Prevent movement if physics inactive
  if not Physics.Active then return end

  self:Face(camera:GetMousePosition())

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
  if Physics.Debug then self.Collider:Draw() end
end