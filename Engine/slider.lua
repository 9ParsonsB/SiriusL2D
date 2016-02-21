Class("Slider")

function Slider:Create(x, y, width, height, min, max)
  self.X, self.Y = x or 0, y or 0
  self.Angle = 0
  self.Width, self.Height = width or 0, height or 0
  self.Min, self.Max = min or 0, max or 1
  self.Value = self.Min
end

function Slider:MouseMoved(x, y, dx, dy)
  
end