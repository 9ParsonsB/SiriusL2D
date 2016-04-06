Object("UnitSystem")

UnitSystem.SelectBox = false
UnitSystem.Box = {}
UnitSystem.Units = {}

function UnitSystem:MousePressed(x, y, button)
  x, y = Camera:GetMousePosition()

  --If left mouse pressed
  if button == 1 then 
    local unit = self:GetUnit(x, y)

    --Move unit to location
    if not unit and self.Unit then 
      --self.Unit:MoveTo(x, y) 
      return
    end

    --Select unit
    if unit and unit.Friendly then 
      if self.Unit then self.Unit.Selected = false end
      
      if self.Unit == unit then
        self.Unit.Selected = false
        self.Unit = nil
        return
      end

      self.Unit = unit 
      unit.Selected = true
      return
    end
    
    --Attack unit
    if unit and not unit.Friendly and self.Unit then
      self.Unit:Attack(unit)
    end
  end

  --If right mouse pressed
  if button == 2 then
    --Start selection box
    if not unit and not self.SelectBox then
      self.SelectBox = true
      self.Box = {X=x, Y=y, Width=1, Height=1}
    end
  end
end

function UnitSystem:MouseReleased(x, y, button)
  if button == 2 and self.SelectBox then 
    
    --Deselect all units

    --Select all units in selection box

    self.SelectBox = false
  end
end

--Sets the size of the selection box
function UnitSystem:MouseMoved(x, y, dx, dy)
  if self.SelectBox then
    self.Box.Width, self.Box.Height = self.Box.Width + dx, self.Box.Height + dy
  end
end

function UnitSystem:Draw()
  if self.SelectBox then
    local rect = self.Box
    Renderer.Box(rect.X, rect.Y, rect.Width, rect.Height, {0, 0, 255, 255})
  end
end

function UnitSystem:GetUnit(x, y)
  local units = Scene.GetObjectsInArea("Unit", x, y, 100, 100)
  return units[1]
end