function Create()
  print("Added movement script to " .. self.Name)
  self.Speed = self.Speed or 0
end

function Update(dt)
 local x, y = self:GetLinearVelocity()

 --WASD acceleration
 if love.keyboard.isDown("w") then y = y - self.Speed * dt end
 if love.keyboard.isDown("a") then x = x - self.Speed * dt end
 if love.keyboard.isDown("s") then y = y + self.Speed * dt end
 if love.keyboard.isDown("d") then x = x + self.Speed * dt end

 self:SetLinearVelocity(x, y)
end