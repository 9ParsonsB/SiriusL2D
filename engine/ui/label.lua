local Widget = require "engine/ui/widget"
local Label = Class("Label", Widget)

function Label:Create(text, x, y, w, h)
  Widget.Create(self, x, y, w, h)
  self.Text = text

  local font = love.graphics.getFont()
  self.Width = w or font:getWidth(text)
end

function Label:Draw(theme)
  theme:Text(self.Text, self.X, self.Y, self.Width, self.Height, theme.Default)
end
return Label