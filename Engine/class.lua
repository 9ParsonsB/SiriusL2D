local Classes = {}

local function Instance(class, ...)
  local self = setmetatable({}, {__index=class})
  if type(self.Create) == "function" then self:Create(...) end
  return self
end

function Class(name, parent)
  --Return existing class
  if Classes[name] then
  	if loading then env[name] = Classes[name] end
    return Classes[name]
  end

  --Create class
  local class = setmetatable({Name=name}, {__call=Instance, __index=parent})
  Classes[name] = class 

  return class
end