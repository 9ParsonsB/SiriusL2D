require "engine"

local game = require "game"
local menu = require "menu"

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  love.graphics.setBackgroundColor(104, 136, 248)
  state = "menu"
end

function love.update(dt)
  if state == "menu" then menu.update(dt)
  elseif state == "game" then game.update(dt) end
end

function love.draw()
  if state == "menu" then menu.draw() 
  elseif state == "game" then game.draw() end
end

function love.mousemoved(x, y, dx, dy)
  if state == "menu" then menu.mousemoved(x, y, dx, dy) 
  elseif state == "game" then game.mousemoved(x, y, dx, dy) end
end

function love.keypressed(key)
  if state == "menu" then menu.keypressed(key) 
  elseif state == "game" then game.keypressed(key) end
end
