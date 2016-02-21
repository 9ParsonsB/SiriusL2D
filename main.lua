require "Engine/core"

--UI
CompileFile("Game/UI/mainMenu.lua")
CompileFile("Game/UI/settingsMenu.lua")
CompileFile("Game/UI/game.lua")

--Game
CompileFile("Game/player.lua")
CompileFile("Game/ship.lua")
CompileFile("Game/pilotSeat.lua")
CompileFile("Game/box.lua")

function love.load()
  love.graphics.setBackgroundColor(104, 136, 248)
  love.physics.setMeter(64)

  Engine.SetState("MainMenu")
  NewObject("MainMenu")
  NewObject("SettingsMenu")
  NewObject("Game")
end