Class("Entity")

Entity.X = 0
Entity.Y = 0
Entity.Angle = 0
Entity.ScaleX = 1
Entity.ScaleY = 1
Entity.Texture = nil

function Entity:SetPosition(x, y)
  x, y = x or 0, y or 0
  if self.Collider then self.Collider:SetPosition(x, y) end--self.Collider:Move(x - self.X, y - self.Y) end
  self.X, self.Y = x, y
end

function Entity:Draw()
  if self.Texture then 
  	Renderer.Sprite(self.Texture, self.X, self.Y, self.Angle, self.ScaleX, self.ScaleY) 
  end
end