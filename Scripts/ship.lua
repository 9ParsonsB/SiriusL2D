Class("Ship", Entity)

function Ship:Create()
  self.Rooms = {}
end

function Ship:AddRoom(room)
  table.insert(self.Rooms, room)
end

--Player ship
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

--Enemy ship
Class("GenericEnemy", Ship)

GenericEnemy.X = 820
GenericEnemy.Y = 380

GenericEnemy.ScaleX = 18
GenericEnemy.ScaleY = 28

GenericEnemy.Texture = "blueRect.png"

function GenericEnemy:Create()
  Ship.Create(self)
  Scene.Add(self)
end