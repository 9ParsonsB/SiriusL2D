function Create(self)
  self.Collider = Physics.Collider(self, "dynamic", "box", 16, 16)
  self.Collider.Body:setFixedRotation(true)
  self.Collider.Fixture:setSensor(true)
end

function Draw(self)
  Renderer.Sprite("greyRect.png", self.X, self.Y)
  self.Collider:Draw()
end