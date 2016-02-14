local Object = require "Engine/object"
local Physics = require "Engine/physics"

local Player = Object("Player")
Player:include("Game/player.lua")

local Box = Object("Box")
Box:include("Game/box.lua")

function love.load()
  love.graphics.setBackgroundColor(104, 136, 248)
  love.physics.setMeter(64)

  player = Object.create("Player", 200, 200)
  box = Object.create("Box", 350, 200)
end

function love.update(dt)
  player.Update(dt)
  player.Collider:Sync(dt)
  Physics.Update(dt)
end

function love.draw()
  player.Draw()
  box.Draw()
end