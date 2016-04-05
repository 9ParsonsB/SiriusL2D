Object("Player")

Player.Animation = "lavaman"
Player.State = "idle"

Player.Physics = {
  Shape = "box",
  Width = 60, 
  Height = 60, 
  FixedRotation = true, 
  Bounciness = 0.9
}

Player.MoveSpeed = 300

function Player:Update(dt)
  if love.keyboard.isDown("w") then self.Y = self.Y - self.MoveSpeed * dt end
  if love.keyboard.isDown("a") then self.X = self.X - self.MoveSpeed * dt end
  if love.keyboard.isDown("s") then self.Y = self.Y + self.MoveSpeed * dt end
  if love.keyboard.isDown("d") then self.X = self.X + self.MoveSpeed * dt end
end

function Player:KeyPressed(key)
  if key == "space" then self:SetVelocity(100, 0) end
end

function Player:MousePressed(x, y, button)
  x, y = Camera:GetMousePosition()
  if button == 1 then
    if x > self.X then self:PlayAnimation("attack") end
    if x < self.X then self:PlayAnimation("attack_back") end
  end
end