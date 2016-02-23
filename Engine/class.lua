local currentEnv
function include(filePath)
  local env = setmetatable({}, {__index=_G})
  currentEnv = env
  
  --Load file in environment
  local chunk = love.filesystem.load(filePath .. ".lua")
  setfenv(chunk, env)
  local result = chunk()

  currentEnv = nil

  return result
end

--Copy table
local function Copy(orig)
  local t = {}
  for k,v in pairs(orig) do t[k] = v end
  setmetatable(t, getmetatable(orig))
  return t
end

--Creates instances
local function Instance(class, ...)
  local self = Copy(class)
  if type(self.Create) == "function" then
    self:Create(...)
  end
  return self
end

--Defines a class
local Classes = {}
function Class(name, super)
  local class = setmetatable({}, {__call=Instance})

  --Inherit from super
  if super then 
    class = Copy(Classes[super]) 
    class.Super = Classes[super]
  end

  --Store class
  class.Name = name
  Classes[name] = class

  --Add class to file thats being loaded
  if currentEnv then 
    currentEnv[name] = class 
  end
  
  return class
end