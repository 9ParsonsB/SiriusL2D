require "Engine"

--Script.Load("Pong/main")

Input.Bind("LEFT", 1)

function love.update(dt)
  print(Input.Down("LEFT"))
end