require "Engine/Common/class"
require "Engine/Common/list"

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

  --Update camera
  Camera:Update(dt)
end

function Engine.draw()
  --Apply camera settings
  Camera:Set() 

  --Draw scene and physics simulation
  Scene.Draw()
  Physics.Draw()

  --Remove camera settings
  Camera:Unset()

  --Draw ui
  Ui.Draw()
end

function Engine.keypressed(key) 
  Scene.Callback("KeyPressed", key) 
  Camera:KeyPressed(key)
end

function Engine.keyreleased(key) 
  Scene.Callback("KeyPressed", key) 
  Camera:KeyReleased(key)
end

function Engine.mousepressed(x, y, button, isTouch) 
  Scene.Callback("MousePressed", x, y, button, isTouch) 
  Camera:MousePressed(x, y, button, isTouch)
end

function Engine.mousereleased(x, y, button, isTouch) 
  Scene.Callback("MouseReleased", x, y, button, isTouch) 
  Camera:MouseReleased(x, y, button, isTouch)
end

function Engine.mousemoved(x, y, dx, dy) 
  Scene.Callback("MouseMoved", x, y, dx, dy)
  Camera:MouseMoved(x, y, dx, dy) 
end

function Engine.wheelmoved(x, y) 
  Scene.Callback("WheelMoved", x, y) 
  Camera:WheelMoved(x, y)
end

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