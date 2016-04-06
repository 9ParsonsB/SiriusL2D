Object("Unit")

Unit.Friendly = true
Unit.Selected = false

Unit.MoveSpeed = 300

function Unit:Attack(unit)
  self.AttackUnit = unit
end

function Unit:Draw()
  if self.Selected then
    Renderer.Box(self.X - 8, self.Y - 8, self.Width, self.Height, {0, 0, 155}, "line")
  end
end

Object("GenericUnit", Unit)
GenericUnit.Texture = "greenRect.png"