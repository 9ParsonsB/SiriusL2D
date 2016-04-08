Object("UnitSystem")

UnitSystem.SelectBox = false
UnitSystem.Box = {}
UnitSystem.Units = List()

function UnitSystem:MousePressed(x, y, button)
  x, y = Camera:GetMousePosition()

  --If left mouse pressed
  if button == 1 then 
    local unit = self:GetUnit(x, y)

    --Move unit to location
    if not unit and self.Units:Any() then 
      --self.Unit:MoveTo(x, y) 
      return
    end

    --Select unit
    if unit and unit.Friendly then    
      if self.Units:Contains(unit) then
        unit.Selected = false
        self.Units:Remove(unit)
        return
      end

      self.Units:Add(unit)
      unit.Selected = true
      return
    end
    
    --Attack unit
    if unit and not unit.Friendly and self.Unit then
      self.Unit:Attack(unit)
    end
  end

  --Start selection box
  if button == 2 then
    if not unit and not self.SelectBox then
      self.SelectBox = true
      self.Box = {X=x, Y=y, Width=1, Height=1}
    end
  end
end

function UnitSystem:MouseReleased(x, y, button)
  if button == 2 and self.SelectBox then 
    
    --Deselect all units
    for k,v in pairs(self.Units.Elements) do v.Selected = false end
    self.Units:Clear()

    --Select all units in selection box
    local units = Scene.GetObjectsInArea("Unit", self.Box.X + self.Box.Width / 2, self.Box.Y + self.Box.Height / 2, self.Box.Width, self.Box.Height)
    for k,v in pairs(units) do
      v.Selected = true 
      self.Units:Add(v)
    end

    self.SelectBox = false
  end
end

--Sets the size of the selection box
function UnitSystem:MouseMoved(x, y, dx, dy)
  if self.SelectBox then self.Box.Width, self.Box.Height = self.Box.Width + dx, self.Box.Height + dy end
end

--Deselect all units
function UnitSystem:KeyPressed(key)
  if key == "a" then 
    for k,v in pairs(self.Units.Elements) do v.Selected = false end
    self.Units:Clear()
  end
end

function UnitSystem:Draw()
  if self.SelectBox then
    local rect = self.Box
    Renderer.Box(rect.X, rect.Y, rect.Width, rect.Height, {0, 0, 255, 255})
  end
end

function UnitSystem:GetUnit(x, y)
  local units = Scene.GetObjectsInArea("Unit", x, y, 10, 10)
  return units[1]
end