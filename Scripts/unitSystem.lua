Object("UnitSystem")

function UnitSystem:MousePressed(x, y, button)
  x, y = Camera:GetMousePosition()

  --If left mouse pressed
  if button == 1 then 
    local unit = self:GetUnit(x, y)

    --Move unit to location
    if not unit and self.Unit then 
      self.Unit:MoveTo(x, y) 
      return
    end

    --Select unit
    if unit and unit.Friendly then 
      self.Unit = unit 
      return
    end

    --Attack unit
    if unit and not unit.Friendly and self.Unit then
      self.Unit:Attack(unit)
    end
  end
end

function UnitSystem:GetUnit(x, y)
  local units = Scene.GetObjects("Unit", x, y, 1, 1)
  return units[1]
end

function UnitSystem:GetUnits(x, y, width, height)
  local units = Scene.GetObjects("Unit", x, y, width, height)
end

function UnitSystem:GetFriendlyUnits(x, y, width, height)
  local units = self:GetUnits(x, y, width, height)
  for k,v in pairs(units) do
    if not v.Friendly then units[k] = nil end
  end
  return units
end

function UnitSystem:GetEnemyUnits(x, y, width, height)
  local units = self:GetUnits(x, y, width, height)
  for k,v in pairs(units) do
    if v.Friendly then units[k] = nil end
  end
  return units
end