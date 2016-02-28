local Entity = Class("Entity")

function Entity:Create(x, y)
  self.Scripts = {}
  self.X, self.Y = x or 0, y or 0
  self.Angle = 0
end

function Entity:AddScript(filePath, ...)
  --Enviroment
  local env = setmetatable({}, {__index=_G})
  env.self = self

  --Load script
  Script.Load(filePath, env)
  table.insert(self.Scripts, env)

  --Create callback
  if type(env.Create) == "function" then env.Create(...) end
end

function Entity:Fire(func, ...)
  for k,v in pairs(self.Scripts) do
  	if type(v[func]) == "function" then v[func](...) end
  end
end

function Entity:Update(dt)
  self:Fire("Update", dt)
  if self.Collider then
    self.X, self.Y = self.Collider:GetPosition()
  end
end

function Entity:Draw()
  if self.Sprite then self.Sprite:Draw(self.X, self.Y, self.Angle) end
  if self.Collider then self.Collider:Draw() end
end

function Entity:SetPosition(x, y)
  if self.Sprite then self.Sprite:Move(x - self.X, y - self.Y) end
  if self.Collider then self.Colldier:Move(x - self.X, y - self.Y) end
  self.X, self.Y = x or 0, y or 0
end

function Entity:SetCollider(type, shape, width, height)
  self.Collider = Physics.Collider(self, type, shape, width, height)
end

function Entity:SetSprite(texture, x, y, angle)
  self.Sprite = Renderer.Sprite(texture, x, y, angle)
end

function Entity:GetLinearVelocity()
  if self.Collider then return self.Collider:GetLinearVelocity() end
  return 0,0
end
function Entity:SetLinearVelocity(x, y)
  if self.Collider then return self.Collider:SetLinearVelocity(x, y) end
end
return Entity