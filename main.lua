require "Engine/engine"
require "Game/Network/client"

--Menus
local MainMenu = require "Game/UI/mainMenu"
local SettingsMenu = require "Game/UI/SettingsMenu"

Engine.SetState("MainMenu")
MainMenu()
SettingsMenu()