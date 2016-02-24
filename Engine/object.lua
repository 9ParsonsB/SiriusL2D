Object = Class("Object")

Object.Directory = ""

function Object:Create(name, x, y)
  self.Scripts = {}
  self.Name = name
  self.X, self.Y = x or 0, y or 0
  self.Angle = 0
end

function Object:AddScript(filePath)
  --Script has its own enviroment
  local env = setmetatable({}, {__index=_G})
  env.self = self

  --Load script
  local chunk = love.filesystem.load(Object.Directory .. filePath)
  setfenv(chunk, env)
  chunk()

  --Script constructor
  if type(env.Create) == "function" then
    env.Create()
  end

  --Stpre script
  table.insert(self.Scripts, env)
end

function Object:Fire(name, ...)
  for k, v in pairs(self.Scripts) do
  	if type(v[name]) == "function" then v[name](...) end
  end
end

function Object:Update(dt)
  self:Fire("Update", dt)
end

function Object:Draw()
  if self.Sprite then self.Sprite:Draw() end
  if self.Collider then self.Collider:Draw() end
end

function Object:SetPosition(x, y)
  if self.Sprite then self.Sprite:Move(x - self.X, y - self.Y) end
  if self.Collider then self.Colldier:Move(x - self.X, y - self.Y) end
  self.X, self.Y = x or 0, y or 0
end

function Object:SetCollider(type, shape, width, height)
  self.Collider = Physics.Collider(self, type, shape, width, height)
end

function Object:SetSprite(texture, x, y, angle)
  self.Sprite = Renderer.Sprite(texture, self.X + x, self.Y + y, self.Angle + angle)
end