require "Engine/core"

--Menus
CompileFile("Game/mainMenu.lua")
CompileFile("Game/debug.lua")

--Game
CompileFile("Game/player.lua")
CompileFile("Game/ship.lua")
CompileFile("Game/pilotSeat.lua")
CompileFile("Game/box.lua")

--Create objects
Engine.SetState("MainMenu")
NewObject("MainMenu")
NewObject("SettingsMenu")

function love.load()
  love.graphics.setBackgroundColor(104, 136, 248)
  love.physics.setMeter(64)
end

function love.update(dt)
  Engine.Update(dt)
end

function love.draw()
  Engine.Draw()
end

function love.keypressed(key)
  Engine.KeyPressed(key)

  if key == "escape" then 
    if Engine.State == "MainMenu" then love.event.quit() end
    if Engine.State == "Game" then Engine.SetState("MainMenu") end
  end

  if key == "1" then Physics.Debug = not Physics.Debug end
  if key == "2" then Physics.Active = not Physics.Active end
end

function love.mousepressed(x, y, button, istouch)
   Engine.MousePressed(x, y, button, isTouch)
end

function love.mousereleased(x, y, button)
   Engine.MouseReleased(x, y, button)
end