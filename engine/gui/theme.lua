local Theme = class("Theme")

Theme.CornerRadius = 5
Theme.Default = { 255, 255, 255 }
Theme.Hover = { 0, 0, 224}
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

function Theme:Text(text, x, y, w, h, colour)
  x, y = x or 0, y or 0
  w, h = w or 0, h or 0

  --Store settings
  local r,g,b,a = love.graphics.getColor()
  local font = love.graphics.getFont()

  --Draw text
  love.graphics.setColor(colour or r,g,b,a)
  love.graphics.printf(text, x, y + 2, w + (w - 4))

  --Restore settings
  love.graphics.setFont(font)
  love.graphics.setColor(r,g,b,a)
end
return Theme