function Create(self)
  self.MoveSpeed = 300
  self.Path = {}
end

function Update(self, dt)
  Transform.FollowPath(self, self.Path, self.MoveSpeed)
  Scene.Camera:SetPosition(self.X, self.Y)
end

function MousePressed(self, x, y, button, isTouch)
  if button == 1 and #self.Path == 0 then 
    self.Path = Scripts.Game.Map:PathFind(self.X, self.Y, Scene.Camera:GetMousePosition()) 
  end
end

function Draw(self)
  Renderer.Sprite("greenRect.png", self.X, self.Y)
  Renderer.Path(self, self.Path, {0, 0, 0})
end

function DrawUi(self)
  Ui.Label(string.format("Player position X:%i Y:%i", self.X, self.Y), 0, 40, 100)
end