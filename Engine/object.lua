Object = {}
function Object.Load(filePath)
  local obj = setmetatable({}, {__index=_G, __call=Object.Create})
  obj.chunk = love.filesystem.load(filePath)
  return obj
end
function Object.Create(obj, ...)
  local self = setmetatable({}, {__index=_G})
  setfenv(obj.chunk, self)
  obj.chunk()

  --Create callback
  if type(self.Create) == "function" then
    self.Create(...)
  end

  return self
end