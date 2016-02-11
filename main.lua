local Object = require "Engine/object"
local Physics = require "Engine/physics"

function love.load()
  love.graphics.setBackgroundColor(104, 136, 248)
  love.physics.setMeter(64)

  Physics.Debug = true

  --Load objects
  Object.Load("debug")
  Object.Load("player", "character")
  Object.Load("wall")

  --Create objects
  Object("debug")
  Object("player", 100, 100)
  Object("wall")
end

function love.update(dt)
  for k,v in pairs(Object.Instances) do
    if type(k.Update) == "function" then k.Update(dt) end
  end
  Physics.Update(dt)
end

function love.draw()
  for k,v in pairs(Object.Instances) do
    if type(k.Draw) == "function" then k.Draw() end
  end
  Physics.Draw()
end

function love.keypressed(key)
  for k,v in pairs(Object.Instances) do
    if type(k.KeyPressed) == "function" then k.KeyPressed(key) end
  end
end

--Feature list
--Screen manager(Show/hide menus etc)
--Methods to get all objects of type
--Object destruction