require "engine"

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  love.graphics.setBackgroundColor(104, 136, 248)
end
