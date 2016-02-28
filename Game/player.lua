Class("Player", Scene.Entity)

Player.Speed = 300

function Player:Create(x, y)
  Entity.Create(self, x, y)

  self:SetSprite("greenRect.png")
  self.Sprite:Center()
  
  self:SetCollider("dynamic", "box", 16, 16)
  self:AddScript("Game/movement")

  Scene.Add(self)
end
return Player