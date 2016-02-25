local Theme = Class("Theme")

Theme.CornerRadius = 5
Theme.Default = { 224, 224, 224 }
Theme.Hover = { 0, 153, 0}
Theme.TextColour = { 0, 0, 0}

function Theme:Box(x, y, w, h, colour)
  --Store settings
  local r,g,b,a = love.graphics.getColor()

  --Draw box
  love.graphics.setColor(colour or r,g,b,a)
  love.graphics.rectangle('fill', x, y, w, h, self.CornerRadius)

  --Restore settings
  love.graphics.setColor(r,g,b,a)
end

function Theme:Text(widget, text, x, y, w, h)
  x, y = x or 0, y or 0
  w, h = w or 0, h or 0

  --Store settings
  local font = love.graphics.getFont()

  --Draw text
  love.graphics.setColor(self.TextColour)
  love.graphics.printf(text, widget.X + x, widget.Y + y + 2, widget.Width + (w - 4), widget.Allign)

  --Restore settings
  love.graphics.getFont(font)
end
return Theme