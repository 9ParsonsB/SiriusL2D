local Widget = require "Engine/Ui/widget"
local Label = Class("Label", Widget)

function Label:Create(text, x, y, w, h)
  Widget.Create(self, x, y, w, h)
  self.Text = text
end

function Label:Draw(theme)
  theme:Text(self, self.Text)
end
return Label