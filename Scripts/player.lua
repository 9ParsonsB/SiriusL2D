Class("Player", Ship)

Player.X = 340
Player.Y = 360

Player.ScaleX = 30
Player.ScaleY = 25

Player.Texture = "greenRect.png"

function Player:Create()
  Ship.Create(self)
  Scene.Add(self)

  --self:AddRoom(PilotRoom(x, y))
end