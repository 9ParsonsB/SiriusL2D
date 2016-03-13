Class("Ship", Entity)

function Ship:Create()
  self.Rooms = {}
end

function Ship:AddRoom(room, x, y)
  room:SetPosition(self.X + x, self.Y + y)
  table.insert(self.Rooms, room)
end

--Player ship
Class("Player", Ship)

Player.X = 150
Player.Y = 200

Player.ScaleX = 50
Player.ScaleY = 28

Player.Texture = "greenRect.png"

function Player:Create()
  Ship.Create(self)
  Scene.Add(self)
end

--Enemy ship
Class("GenericEnemy", Ship)

GenericEnemy.X = 1050
GenericEnemy.Y = 150

GenericEnemy.ScaleX = 30
GenericEnemy.ScaleY = 35

GenericEnemy.Texture = "blueRect.png"

function GenericEnemy:Create()
  Ship.Create(self)
  Scene.Add(self)
end