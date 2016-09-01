local Player = require "player"
local game = {}

local camera = Camera(512, 384)
local player = Player(512, 384)

local follow = false

function game.update(dt)
  player:update(dt)
  if follow then camera.x, camera.y = player.x, player.y end
end

function game.draw()
  camera:push()
  player:draw()
  camera:pop()
  player:ui()
end

function game.mousemoved(x, y, dx, dy)
  player:mousemoved(x, y, dx, dy)
end

function game.keypressed(key)
  if key == "escape" then state = "menu" end
end

return game