local Widget = class("Widget")

Widget.X = 0
Widget.Y = 0
Widget.Width = 0
Widget.Height = 0
Widget.Type = "Widget"
Widget.Theme = "Default"
Widget.Allign = "left"

function Widget:Create(x, y, w, h)
  self.X, self.Y = x or 0, y or 0
  self.Width, self.Height = w or 0, h or 0
  table.insert(Ui.Widgets, self)
end
function Widget:Draw(theme) end

return Widget