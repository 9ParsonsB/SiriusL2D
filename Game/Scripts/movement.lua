Speed = 300

function Update(dt)
  if not Physics.Active then return end

  --Get velocity
  local x, y = self:GetLinearVelocity()

  --WASD acceleration
  if love.keyboard.isDown("w") then y = y - Speed * dt end
  if love.keyboard.isDown("a") then x = x - Speed * dt end
  if love.keyboard.isDown("s") then y = y + Speed * dt end
  if love.keyboard.isDown("d") then x = x + Speed * dt end

  --Set new velocity
  self:SetLinearVelocity(x, y)
end