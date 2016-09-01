
local function instance(class, ...)
  local self = setmetatable({}, {__index = class})
  if type(self.create) == "function" then self:create(...) end
  return self
end

function Class(name, parent)
  return setmetatable({Name = name}, {__call = instance, __index = parent})
end

function typeof(self)
  return getmetatable(self).__index
end
