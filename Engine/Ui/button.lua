local Widget = require "Engine/Ui/widget"
local Button = Class("Button", Widget)

Button.Pressed = false
Button.Hover = false

function Button:Create(text, x, y, w, h)
  Widget.Create(self, x, y, w, h)
  self.Text = text
  self.Hover = Ui.MouseOver(self)
  self.Pressed = Ui.LMouse and self.Hover

  local font = love.graphics.getFont()
  self.Width = w or font:getWidth(text)
end

function Button:Draw(theme)
  --Get colour for button
  local colour = theme.Default
  if self.Hover then colour = theme.Hover end
  
  --Draw button
  --theme:Box(self.X, self.Y, self.Width, self.Height)
  theme:Text(self.Text, self.X, self.Y, self.Width, self.Height, colour)
end
return Button