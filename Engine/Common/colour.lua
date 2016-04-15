local Colour = Class("Colour")

function Colour:Create(r, g, b, a)
  self.R, self.G, self.B, self.A = r, g, b, a
end

return Colour