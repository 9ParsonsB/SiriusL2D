Speed = 300

function Create()
  SetCollider({Type="dynamic", Shape="box", Width=16, Height=16})
  State.Add(self, "Game")
end

function Update(dt)
  local camera = State.GetCamera("Game")
  camera.X = X - (love.graphics.getWidth() / 2) + 8
  camera.Y = Y - (love.graphics.getHeight() / 2) + 8

  Face(love.mouse.getPosition())

  --WASD movement
  local x, y = GetLinearVelocity()
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