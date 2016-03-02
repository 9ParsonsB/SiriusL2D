function Create(speed)
  Speed = speed or 0
end

function Update(dt)
 self:SetLinearVelocity(0, 0)
 if love.keyboard.isDown("w") then self:SetLinearVelocity(0, -Speed) end
 if love.keyboard.isDown("s") then self:SetLinearVelocity(0, Speed) end

 --WASD acceleration
 --[[local x, y = self:GetLinearVelocity()

 if love.keyboard.isDown("w") then y = y - Speed * dt end
 if love.keyboard.isDown("a") then x = x - Speed * dt end
 if love.keyboard.isDown("s") then y = y + Speed * dt end
 if love.keyboard.isDown("d") then x = x + Speed * dt end

 self:SetLinearVelocity(x, y)--]]
end