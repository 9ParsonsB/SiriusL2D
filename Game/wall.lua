Class("Wall", Scene.Entity)

function Wall:Create(x, y, width, height)
  Entity.Create(self, x, y)

  self:SetSprite("greenRect.png")
  self.Sprite:SetSize(width, height)
  self.Sprite:Center()
  
  self:SetCollider("static", "box", width, height)

  Scene.Add(self)
end
return Wall