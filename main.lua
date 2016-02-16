require "Engine/core"

CompileFile("debug.lua")
CompileFile("player.lua")
CompileFile("box.lua")

function love.load()
  love.graphics.setBackgroundColor(104, 136, 248)
  love.physics.setMeter(64)

  NewObject("Debug")
  NewObject("Player")
  NewObject("Box", 300, 250, 700, 50)
end

function love.update(dt)
  State.Update("Game", dt)
  Physics.Update(dt)
end

function love.draw()
  State.Draw("Game")
  State.Draw("Debug")
end

function love.keypressed(key)
  --Exit game with esc
  if key == "escape" then love.event.quit() end

  --Toggle keys
  if key == "1" then Physics.Debug = not Physics.Debug end
  if key == "2" then Physics.Active = not Physics.Active end
  if key == "3" then State.Get("Debug").Visible = not State.Get("Debug").Visible end
end