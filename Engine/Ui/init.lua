Ui = {
  Widgets = {},
  LMouse = false,

  Theme = require "Engine/Ui/theme",
  Button = require "Engine/Ui/button",
  Label = require "Engine/Ui/label",
  Slider = require "Engine/Ui/slider"
}

function Ui.Update(dt)
  Ui.LMouse = false
  Ui.Widgets = {}
end

function Ui.Draw()
  for k,v in pairs(Ui.Widgets) do v:Draw(Ui.Theme) end
end

function Ui.GetTextHeight(text, limit)
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
end

function Ui.MouseOver(widget)
  local x, y = love.mouse.getPosition()
  return x >= widget.X and x <= widget.X + widget.Width
  and y >= widget.Y and y <= widget.Y + widget.Height
end