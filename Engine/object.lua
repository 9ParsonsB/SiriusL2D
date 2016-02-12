local Group = require "Engine/group"
local Physics = require "Engine/physics"
local Renderer = require "Engine/renderer"
local Events = require "Engine/events"

local Object = {}

Object.Classes = {}
Object.Scripts = {}
Object.Dir = "Game/"
Object.Instances = setmetatable({}, {__mode="k"})

--Loads a class
function Object.Load(name, base)
  --Create class
  local class = setmetatable({},  {__call=Object.New})

  --Get filename from relative path
  class.Name = name:match("([^/]+)$")
  
  --Load script for class definition
  class.Script = Object.Scripts[name] or love.filesystem.load(Object.Dir .. name .. ".lua")
  Object.Scripts[name] = class.Script

  --Store class for object creation
  Object.Classes[class.Name] = class
  Object.Instances[class.Name] = {}
end

--Runs class constructor
function Object.Create(self, name, ...)
  if Object.Classes[name] then
    return Object.Classes[name](...)
  end
end

--Create object from class
function Object.New(class, ...)
  local env = {}
  env.self = env
  env.name = class.Name

  --Engine
  env.Object = Object
  env.Group = Group
  env.Physics = Physics
  env.Renderer = Renderer

  --Core
  env.love = love
  env.print = print
  env.collectgarbage = collectgarbage
  env.math = math

  --Load script into objects enviroment
  setfenv(class.Script, env)
  class.Script()
    
  --Run constructor if one exists
  if type(env.Create) == "function" then
    env.Create(...)
  end

  --Store instance
  Object.Instances[class.Name][env] = class.Name

  return env
end

function Object.Destroy(env)
  --Run destructor if one exists
  if type(env.Destroy) == "function" then
    env.Destroy()
  end
  Screen.Remove(env)
end

--Gets all objects of type
function Object.GetAll(name)
  return Object.Instances[name]
end
return setmetatable(Object, {__call=Object.Create})

--Set enviroment using loadfile. love2d used lua 5.1 so setfenv and getfenv can be used.
--local path = love.filesystem.getRealDirectory("") .. "/" .. Script.Dir .. class .. ".lua"
--assert(loadfile(path, 't', env))()