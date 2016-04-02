Class("Player")

Player.Path = {}
Player.Animation = "lavaman"
Player.State = "idle"
--Player.Texture = "greenRect.png"

Player.MoveSpeed = 200

function Player:Create(x, y)
  self.X, self.Y = x or 0, y or 0

  Scene.Camera:SetPosition(self.X, self.Y)
  Scene.Add(self)
end

function Player:Update(dt)
  Transform.FollowPath(self, self.Path, self.MoveSpeed)
end

function Player:MousePressed(x, y, button, isTouch)
  x, y = Scene.Camera:GetMousePosition()
  if button == 1 then self.Path = Game.Map:PathFind(self.X, self.Y, x, y) end
end