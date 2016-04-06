Object("Player")

Player.Animation = "lavaman"

Player.UsePhysics = true
Player.Width = 50
Player.Height = 50
Player.FixedRotation = true

Player.MoveSpeed = 300

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