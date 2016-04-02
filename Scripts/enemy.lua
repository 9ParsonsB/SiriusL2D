Class("Enemy")

Enemy.Texture = "blackRect.png"

function Enemy:Create(x, y)
  self.X, self.Y = x or 0, y or 0
  self.Path = Game.Map:PathFind(x, y, x, y)

  Scene.Add(self)
end

function Enemy:Update(dt)
  Transform.FollowPath(self, self.Path, 300)
end