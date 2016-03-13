local Theme = require "Engine/Ui/theme"
local Button = require "Engine/Ui/button"
local Label = require "Engine/Ui/label"
local Slider = require "Engine/Ui/slider"

Ui = {
  LMouse = false,
  Widgets = {},
  Theme = Theme
}

function Ui.Update()
  Ui.LMouse = false
end

function Ui.Draw()
  for k,v in pairs(Ui.Widgets) do v:Draw(Ui.Theme) end
  Ui.Widgets = {}
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

function Ui.Button(text, x, y, w, h)
  local button = Button(text, x, y, w, h)
  table.insert(Ui.Widgets, button)
  return button
end

function Ui.Label(text, x, y, w, h)
  local label = Label(text, x, y, w, h)
  table.insert(Ui.Widgets, label)
  return label
end

function Ui.Slider(info, x, y, w, h)
  local slider = Slider(info, x, y, w, h)
  table.insert(Ui.Widgets, slider)
  return slider
end

function Ui.MousePressed(x, y, button, isTouch)
  if button == 1 then Ui.LMouse = true end
end

function Ui.MouseOver(widget)
  local x, y = love.mouse.getPosition()
  return x >= widget.X and x <= widget.X + widget.Width
  and y >= widget.Y and y <= widget.Y + widget.Height
end