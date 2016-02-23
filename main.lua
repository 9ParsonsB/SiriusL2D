require "Engine/engine"
require "Game/Network/client"

--Menus
local MainMenu = require "Game/UI/mainMenu"
local SettingsMenu = require "Game/UI/settingsMenu"

Engine.SetState("MainMenu")
MainMenu()
SettingsMenu()