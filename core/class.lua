local function instance(class, ...)
  local mt = class
  mt.__index = class
  local self = setmetatable({}, class)
  if type(self.init) == "function" then self:init(...) end
  return self
end
function class(name, parent)
  return setmetatable({name = name}, {__call = instance, __index = parent})
end
return class