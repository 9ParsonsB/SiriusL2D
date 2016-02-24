local MainMenu = require "Game/UI/mainMenu"
local SettingsMenu = require "Game/UI/settingsMenu"

--Ui settings
Ui.Button.Texture = "greyRect.png"
Ui.Button.Hover = "greenRect.png"
Ui.Button.EnableTexture = "greenRect.png"
Ui.Button.DisableTexture = "blueRect.png"

--Create menus
Engine.SetState("MainMenu")
MainMenu()
SettingsMenu()