local Classes = {}

local function Instance(class, ...)
  local self = setmetatable({}, {__index=class})
  if type(self.Create) == "function" then self:Create(...) end
  return self
end

function Class(name, parent)
  --Return existing class table
  if Classes[name] then
    for k in pairs(Classes[name]) do Classes[name][k] = nil end
    return Classes[name]
  end

  --Create class
  local class = setmetatable({Name=name}, {__call=Instance, __index=parent})
  Classes[name] = class 

  return class
end