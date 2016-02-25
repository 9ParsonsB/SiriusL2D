--Ui settings
Ui.Button.Texture = "greyRect.png"
Ui.Button.Hover = "greenRect.png"
Ui.Button.EnableTexture = "greenRect.png"
Ui.Button.DisableTexture = "blueRect.png"

local MainMenu = require "Game/Ui/mainMenu"
local SettingsMenu = require "Game/Ui/settingsMenu"

--Create menus
Engine.SetState("MainMenu")
MainMenu()
SettingsMenu()