require "Engine/script"
require "Engine/class"

require "Engine/Network"
require "Engine/Physics"
require "Engine/Renderer"
require "Engine/Ui"
require "Engine/Utility"

local Engine = {}

function Engine.load()
  love.graphics.setBackgroundColor(104, 136, 248)
  love.physics.setMeter(64)
end

function Engine.update(dt)
  Script.Update(dt)
  Ui.Update(dt)
  Physics.Update(dt)
end

function Engine.draw()
  Script.Draw()
  Ui.Draw()
end

function Engine.keypressed(key)
  Script.KeyPressed(key)
end
function Engine.keyreleased(key)
  Script.KeyReleased(key)
end
function Engine.mousepressed(x, y, button, isTouch)
  Script.MousePressed(x, y, button, isTouch)
  Ui.MousePressed(x, y, button, isTouch)
end
function Engine.mousereleased(x, y, button)
  Script.MouseReleased(x, y, button, isTouch)
end
function Engine.mousemoved(x, y, dx, dy)
  Script.MouseMoved(x, y, dx, dy)
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