Speed = 300
function Create()
  SetCollider({Type="dynamic", Shape="box", Width=16, Height=16})
end
function Update(dt)
  Face(love.mouse.getPosition())

  local x, y = GetLinearVelocity()

  --WASD movement
  if love.keyboard.isDown("w") then y = y - Speed * dt end
  if love.keyboard.isDown("a") then x = x - Speed * dt end
  if love.keyboard.isDown("s") then y = y + Speed * dt end
  if love.keyboard.isDown("d") then x = x + Speed * dt end

  SetLinearVelocity(x, y)
end
function Draw()
  DrawSprite("greenRect.png", X, Y, Angle)
  DrawCollider()
end