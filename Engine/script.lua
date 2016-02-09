local Class = require "Engine/30log"
local Renderer = require "Engine/renderer"
local Events = require "Engine/events"

local Script = {}

Script.Files = {}

function Script.Load(filePath)
  --Load once if file returns result
  if Script[filePath] then return Script[filePath] end

  local env = {}

  --Default enviroment values
  env.Class = Class
  env.Script = Script
  env.Renderer = Renderer
  env.love = love
  env.World = World
  env.print = print
  env.collectgarbage = collectgarbage

  --Load file
  local path = love.filesystem.getRealDirectory("") .. "/" .. filePath .. ".lua"
  Script[filePath] = assert(loadfile(path, 't', env))()

  return Script[filePath]
end
return Script