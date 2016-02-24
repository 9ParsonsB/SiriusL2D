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
    class = Copy(super) 
    class.Super = super
  end

  --Store class
  class.Name = name
  Classes[name] = class
  
  return class
end