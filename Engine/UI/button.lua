local Widget = require "Ui/widget"
local Button = Class("Button", Widget)

Button.Pressed = false
Button.Hover = false

function Button:Create(text, x, y, w, h)
  Widget.Create(self, x, y, w, h)
  self.Text = text
  self.Hover = Ui.MouseOver(self)
  self.Pressed = Ui.LMouse and self.Hover
end

function Button:Draw(theme)
  --Get colour for button
  local colour = theme.Default
  if self.Hover then colour = theme.Hover end
  
  --Draw button
  theme:Box(self.X, self.Y, self.Width, self.Height, colour)
  theme:Text(self, self.Text)
end
return Button