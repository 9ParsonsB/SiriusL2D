Ui = {}

Ui.Menus = {}
Ui.LMouse = false
Ui.Menu = require "Ui/menu"

function Ui.Update(dt)
  for k,v in pairs(Ui.Menus) do 
  	if v.Active then v:Update(dt) end
  end
  Ui.LMouse = false 
end

function Ui.Draw()
  for k,v in pairs(Ui.Menus) do v:Draw() end
end

function Ui.KeyPressed(key)
  for k,v in pairs(Ui.Menus) do v:KeyPressed(key) end
end

function Ui.MousePressed(x, y, button, isTouch)
  if button == 1 then Ui.LMouse = true end
end

function Ui.MouseOver(widget)
  local x, y = love.mouse.getPosition()
  return x >= widget.X and x <= widget.X + widget.Width
  and y >= widget.Y and y <= widget.Y + widget.Height
end