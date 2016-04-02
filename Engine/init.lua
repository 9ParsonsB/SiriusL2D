require "Engine/class"

require "Engine/Network"
require "Engine/Physics"
require "Engine/Renderer"
require "Engine/Scene"
require "Engine/Ui"
require "Engine/Transform"

local Engine = {}

function Engine.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  love.graphics.setBackgroundColor(104, 136, 248)
  love.graphics.setLineStyle("smooth")
end

function Engine.update(dt)
  Ui.Update(dt)
  Scene.Update(dt)
  Physics.Update(dt)
end

function Engine.draw()
  Scene.Draw()
  Ui.Draw()
end

function Engine.keypressed(key) 
  Scene.Callback("KeyPressed", key) 
end
function Engine.keyreleased(key) 
  Scene.Callback("KeyReleased", key) 
end
function Engine.mousepressed(x, y, button, isTouch)
  Scene.Callback("MousePressed", x, y, button, isTouch)
  Ui.MousePressed(x, y, button, isTouch)
end
function Engine.mousereleased(x, y, button) 
  Scene.Callback("MouseReleased", x, y, button)
end
function Engine.mousemoved(x, y, dx, dy)
  Scene.Callback("MouseMoved", x, y, dx, dy)
end

--Connect engine callbacks to love2d
love.load = Engine.load
love.update = Engine.update
love.draw = Engine.draw
love.keypressed = Engine.keypressed
love.keyreleased = Engine.keyreleased
love.mousepressed = Engine.mousepressed
love.mousereleased = Engine.mousereleased
love.mousemoved = Engine.mousemoved

return Engine