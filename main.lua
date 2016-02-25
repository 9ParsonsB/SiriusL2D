require "Engine/engine"
require "Game/Network/client"
require "Game/Menus/mainMenu"
require "Game/Menus/settingsMenu"

Object.Directory = "Game/Scripts/"

local player = Object("Player")
player:AddScript("player.lua")
player:AddScript("movement.lua")
