local Group = require "Engine/group"
local Object = require "Engine/object"
local Physics = require "Engine/physics"

function love.load()
  love.graphics.setBackgroundColor(104, 136, 248)
  love.physics.setMeter(64)

  --Set camera for game
  Group.SetCamera("Game", 0, 0)

  --Load objects
  Object.Load("mainMenu")
  Object.Load("debug")
  Object.Load("player", "character")
  Object.Load("wall")

  --Create objects
  Object("mainMenu")
  Object("debug")
  Object("player", 100, 100)
  Object("wall")
end

function love.update(dt)
  Group.Get("Game"):Update(dt)
  Physics.Update(dt)
end

function love.draw()
  Group.Get("Debug"):Draw(dt)
  Group.Get("Game"):Draw(dt)
end

function love.keypressed(key)
  Group.Get("Game"):KeyPressed(key)
end

function love.keyreleased(key)
 Group.Get("Game"):KeyReleased(key)
end

--Feature list
--Cameras for screens
--Object destruction