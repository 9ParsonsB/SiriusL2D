require "Engine/script"

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
function Class(name, subclass)
  local class = setmetatable({}, {__call=Instance})

  if subclass and Classes[subclass] then 

    --Inherit from subclass
    local super = Copy(Classes[subclass])
    class = super
    class.SubClass = subclass

    --Add subclass to file
    if Script.Env then
      Script.Env[subclass] = Classes[subclass]
    end
  end

  --Store class
  class.Name = name
  Classes[name] = class
  
  --Add class to file
  if Script.Env then
    Script.Env[name] = class
  end

  return class
end

--[[function AddScript(object, script)
  object.Scripts = object.Scripts or {}
  table.insert(object.Scripts, script)
end--]]