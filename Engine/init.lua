require "Engine/class"

require "Engine/Network"
require "Engine/Physics"
require "Engine/Renderer"
require "Engine/Scene"
require "Engine/Ui"

local Engine = {}

function Engine.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  love.graphics.setBackgroundColor(104, 136, 248)
end

function Engine.update(dt)
  Ui.Update(dt)
  Scene.Update(dt)
  Physics.Update(dt)
  Script.Reload()
end

function Engine.draw()
  Camera:Set() 
  Scene.Draw()
  Physics.Draw()
  Camera:Unset()
  Ui.Draw()
end

function Engine.keypressed(key) Scene.Callback("KeyPressed", key) end
function Engine.keyreleased(key) Scene.Callback("KeyPressed", key) end
function Engine.mousepressed(x, y, button, isTouch) Scene.Callback("MousePressed", x, y, button, isTouch) end
function Engine.mousereleased(x, y, button, isTouch) Scene.Callback("MouseReleased", x, y, button, isTouch) end
function Engine.mousemoved(x, y, dx, dy) Scene.Callback("MouseMoved", x, y, dx, dy) end
function Engine.wheelmoved(x, y) Scene.Callback("WheelMoved", x, y) end

--Connect engine to love2d
love.load = Engine.load
love.update = Engine.update
love.draw = Engine.draw
love.keypressed = Engine.keypressed
love.keyreleased = Engine.keyreleased
love.mousepressed = Engine.mousepressed
love.mousereleased = Engine.mousereleased
love.mousemoved = Engine.mousemoved
love.wheelmoved = Engine.wheelmoved

return Engine