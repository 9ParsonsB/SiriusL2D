Object("Unit")

function Unit:Attack(unit)
  self.AttackUnit = unit
end


Object("GenericUnit", Unit)
GenericUnit.Texture = "greenRect.png"