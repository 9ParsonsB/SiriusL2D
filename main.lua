require "Engine"
require "Game/Menus/mainMenu"
require "Game/Menus/settingsMenu"

local Player = Script.Load("Game/player")
local a = Player(100, 100)

local Wall = Script.Load("Game/wall")
Wall(200,100, 50, 50)

--Scene.Remove(a)

--[[local env = {}
local chunk = loadstring("print('UNSAFE')")
setfenv(chunk, {})
chunk()--]]