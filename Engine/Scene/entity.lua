local Entity = Class("Entity")

Entity.X = 0
Entity.Y = 0
Entity.Angle = 0

function Entity:Create()
  self.Scripts = {}
  self.Ids = {}
end

--Add script to entity
function Entity:AddScript(chunk, ...)
  --Load script
  local script = setmetatable({}, {__index=_G})
  setfenv(chunk, script)
  chunk()

  --Create script
  script.self = self
  if type(script.Create) == "function" then script.Create(...) end

  --Store script
  table.insert(self.Scripts, script)
  self.Ids[chunk] = #self.Scripts
end

--Get script from entity
function Entity:GetScript(script)
  local index = self.Ids[script]
  if index then return self.Scripts[index] end
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
  x, y = x or 0, y or 0
  if self.Collider then self.Collider:SetPosition(x, y) end--self.Collider:Move(x - self.X, y - self.Y) end
  self.X, self.Y = x, y
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