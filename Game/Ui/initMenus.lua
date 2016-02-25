--Ui settings
Ui.Button.Texture = "greyRect.png"
Ui.Button.Hover = "greenRect.png"
Ui.Button.EnableTexture = "greenRect.png"
Ui.Button.DisableTexture = "blueRect.png"

local MainMenu = require "Game/UI/mainMenu"
local SettingsMenu = require "Game/UI/settingsMenu"

--Create menus
Engine.SetState("MainMenu")
MainMenu()
SettingsMenu()