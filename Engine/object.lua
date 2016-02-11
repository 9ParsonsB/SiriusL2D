local Physics = require "Engine/physics"
local Renderer = require "Engine/renderer"
local Events = require "Engine/events"

local Object = {}

Object.Classes = {}
Object.Scripts = {}
Object.Dir = "Game/"
Object.Instances = {}

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

  --Store object
  Object.Instances[env] = class.Name

  return env
end

--Gets all objects of type
function Object.GetAll(name)
  local objects = {}
  local count = 0
  for k,v in pairs(Object.Instances) do
    if k.name == name then
      objects[count] = k
      count = count + 1
    end
  end
  return objects
end
return setmetatable(Object, {__call=Object.Create})

--Set enviroment using loadfile. love2d used lua 5.1 so setfenv and getfenv can be used.
--local path = love.filesystem.getRealDirectory("") .. "/" .. Script.Dir .. class .. ".lua"
--assert(loadfile(path, 't', env))()