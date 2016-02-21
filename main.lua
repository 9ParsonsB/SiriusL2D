require "Engine/core"

--[[
Engine feature list:
- Files can be loaded in their own enviroment

- Class creation

- Object creation

- Inheritance

- State manager adds love2d callbacks
to objects

- Entities

- Buttons
--]]

--UI
CompileFile("UI/mainMenu.lua")
CompileFile("UI/settingsMenu.lua")
CompileFile("UI/game.lua")

--Game
CompileFile("Game/player.lua")
CompileFile("Game/ship.lua")
CompileFile("Game/pilotSeat.lua")
CompileFile("Game/box.lua")

function love.load()
  love.graphics.setBackgroundColor(104, 136, 248)
  love.physics.setMeter(64)

  --Game starts in main menu
  Engine.SetState("MainMenu")

  --Create GUI
  NewObject("MainMenu")
  NewObject("SettingsMenu")
  NewObject("Game")
end