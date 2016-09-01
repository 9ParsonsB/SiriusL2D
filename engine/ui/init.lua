ui = {}

local widgets = {}
local lmouse = false

function ui.button(text, x, y)
  
end

function ui.draw()
  --for k,v in pairs(Ui.Widgets) do v:Draw(Ui.Theme) end
  --Ui.Widgets = {}
end

function ui.mouseover(x, y, w, h)
  local mx, my = love.mouse.getPosition()
  return mx >= x and mx <= x + w and my >= y and my <= y + h
end


--[[function Ui.GetTextHeight(text, limit)
  --Get number of lines
  local font = love.graphics.getFont()
  local rw, lines = font:getWrap(text, limit)

  --Get height of a line
  local lineheight = font:getLineHeight() * (font:getAscent() + font:getDescent())

  --Return total height
  return #lines * lineheight
end

function Ui.MousePressed(x, y, button, isTouch)
  if button == 1 then Ui.LMouse = true end
end--]]
