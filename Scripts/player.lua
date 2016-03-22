function Draw(self)
  if self == Scripts.UnitSystem.Selected then
    Renderer.Sprite("greenRect.png", self.X, self.Y)
  else 
    Renderer.Sprite("greyRect.png", self.X, self.Y)
  end
end