local Object = require "Engine/object"
local State = require "Engine/state"
local Physics = require "Engine/physics"

function love.load()
  love.graphics.setBackgroundColor(104, 136, 248)
  love.physics.setMeter(64)

  --Load objects
  Object.load("Player", "Game/player.lua")
  Object.load("Box", "Game/box.lua")
  Object.load("Debug", "Game/debug.lua")

  --Create initial objects(Menus etc)
  Object("Debug")
  Object("Player", 200, 200)
  Object("Box", 350, 200)
end

function love.update(dt)
  State.Update("Game", dt)
  Physics.Update(dt)
end

function love.draw()
  State.Draw("Debug")
  State.Draw("Game")
end