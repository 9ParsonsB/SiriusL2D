function Create(entity)
  Entity = entity
end

function Update(dt)
  if Entity then
  	self:SetPosition(self.X, Entity.Y)
  end
end