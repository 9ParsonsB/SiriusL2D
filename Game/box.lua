Class("Box", "Entity")

function Box:Create(x, y, width, height)
  self.X, self.Y = x or 0, y or 0
  self.Width, self.Height = width or 16, height or 16
  self:SetCollider("static", "box", self.Width or 16, self.Height or 16)
  Engine.Add(self, "Game")
end

function Box:Draw()
  Renderer.DrawSprite("greenRect.png", self.X, self.Y, self.Angle, self.Width, self.Height)
  if Physics.Debug then self.Collider:Draw() end
end