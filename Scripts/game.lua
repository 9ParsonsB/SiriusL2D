Class("Game")

Game.Map = Transform.Grid(0, 0, 30, 20)
Game.Map.ShowLines = true

function Game:Create()
  Scene.Add(self)
  
  Debug()
  Player(200, 200)
  CameraControl()
end

function Game:Draw()
  self.Map:Draw()
end

Game()