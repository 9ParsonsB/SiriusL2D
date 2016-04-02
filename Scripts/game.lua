Class("Game")

Game.Map = Transform.Grid(0, 0, 50, 30)
Game.Map.ShowLines = true

function Game:Create()
  Scene.Add(self)
end

function Game:KeyPressed(key)
  if key == "1" then self.Map.ShowLines = not self.Map.ShowLines end
  if key == "2" then self.Map.Debug = not self.Map.Debug end

  if key == "space" then
    Physics.Active = not Physics.Active
    Scene.Active = not Scene.Active
  end
end

function Game:MousePressed(x, y, button, isTouch)
  if button == 2 then
  	self.Map:Toggle(Scene.Camera:GetMousePosition()) 
  end
end

function Game:Draw()
  self.Map:Draw()
end

Game()
Debug()
CameraControl()
Player(200, 200)
Enemy(400, 200)