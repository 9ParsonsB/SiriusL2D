Class("Player")

Player.Path = {}
Player.MoveSpeed = 200
Player.State = "running"

function Player:Create(x, y)
  self.X, self.Y = x or 0, y or 0
  self.Ability1 = SpawnFireball(self, "q")

  Scene.Camera:SetPosition(self.X, self.Y)
  Scene.Add(self)
end

function Player:Update(dt)
  Transform.FollowPath(self, self.Path, self.MoveSpeed)
end

function Player:Draw()
  Renderer.Sprite("greenRect.png", self.X, self.Y)
  Renderer.Path(self, self.Path, {0, 0, 0})
  Renderer.Animation(self, "genericAnimation", self.State, true)
end

function Player:MousePressed(x, y, button, isTouch)
  x, y = Scene.Camera:GetMousePosition()
  if button == 1 then self.Path = Game.Map:PathFind(self.X, self.Y, x, y) end
end