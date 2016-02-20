local Enviroments = {}
local CurrentFile = "None"
local Classes = {}
function CompileFile(filePath)
  --File is being loaded
  CurrentFile = filePath

  --Store enviroment
  local env= setmetatable({}, {__index=_G})
  Enviroments[filePath] = env

  --Load and execute file with enviroment
  local chunk = love.filesystem.load(filePath)
  setfenv(chunk, env)
  chunk()

  --File has been loaded
  CurrentFile = "None"
end
function Class(name, super)
  --Only define classes in a file that is compiled
  if CurrentFile == "None" then
    error("Class must be in a file that is compiled through CompileFile()") 
    return
  end

  --Create class
  local class = {}
  if Classes[super] then
    for k,v in pairs(Classes[super]) do class[k] = v end
  end
  class.name = name
  class.super = Classes[super]

  --Add class to enviroment
  Enviroments[CurrentFile][name] = class
  Classes[name] = class
end
function NewObject(name, ...)
  --Look in class for methods, default values etc
  local object = setmetatable({}, {__index=Classes[name]})

  --Constructor
  if type(object.Create) == "function" then 
  	object:Create(...)
  end

  --Base constructor
  if object.super then 
    if type(object.super.Create) == "function" then
      object.super.Create(object, ...)
    end
  end
  return object
end
function GetClass(name)
  return Classes[name]
end

--Load base files
require "Engine/physics"
require "Engine/renderer"
require "Engine/gui"
require "Engine/engine"

--Compile default classes
CompileFile("Engine/collider.lua")
CompileFile("Engine/entity.lua")