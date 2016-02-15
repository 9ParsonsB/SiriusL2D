local Object = require "Engine/object"
local State = require "Engine/state"
local Physics = require "Engine/physics"

function love.load()
  love.graphics.setBackgroundColor(104, 136, 248)
  love.physics.setMeter(64)

  --Load objects
  Object.Directory = "Game/"
  Object.load("Character", "character.lua")
  Object.load("Player", "player.lua")
  Object.load("Box", "box.lua")
  Object.load("Debug", "debug.lua")

  --Create initial objects(Menus etc)
  Object("Debug")
  Object("Player", 200, 200)
  Object("Box", 350, 300)
end

function love.update(dt)
  State.Update("Game", dt)
  Physics.Update(dt)
end

function love.draw()
  State.Draw("Debug")
  State.Draw("Game")
end

function love.keypressed(key)
  State.KeyPressed("Debug")
  State.KeyPressed("Game")

  --Toggle keys
  if key == "1" then Physics.Debug = not Physics.Debug end
  if key == "2" then Physics.Active = not Physics.Active end
  if key == "3" then State.Get("Debug").Visible = not State.Get("Debug").Visible end
end