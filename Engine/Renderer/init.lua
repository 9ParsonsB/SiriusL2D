Renderer = {
  ContentDir = "Content/", 
  Textures = {}
}

function Renderer.GetTexture(filePath)
  --Return texture if its already loaded
  if Renderer.Textures[filePath] then return Renderer.Textures[filePath] end

  --Load texture
  local texture = love.graphics.newImage(Renderer.ContentDir .. filePath)
  Renderer.Textures[filePath] = texture

  return texture
end

function Renderer.Sprite(filePath, x, y, angle, scaleX, scaleY, offsetX, offsetY)
  local texture = Renderer.GetTexture(filePath)

  --Default values
  x, y = x or 0, y or 0
  angle = angle or 0
  scaleX = scaleX or 1
  scaleY = scaleY or 1

  --Draw sprite
  love.graphics.draw(
  texture, 
  x, y, 
  (math.pi / 180) * angle, 
  scaleX, scaleY, 
  offsetX or texture:getWidth() / 2, offsetY or texture:getHeight() / 2)
end

function Renderer.Line(x1, y1, x2, y2, colour)
  --Set colour
  local r, g, b, a = love.graphics.getColor()
  love.graphics.setColor(colour)

  --Draw line
  love.graphics.line(x1, y1, x2, y2)

  --Restore colour
  love.graphics.setColor(r,g,b,a)
end

function Renderer.Lines(lines, colour)
  --Set colour
  local r, g, b, a = love.graphics.getColor()
  love.graphics.setColor(colour)

  --Draw lines
  for i=1, #lines-1 do
    love.graphics.line(lines[i].X, lines[i].Y, lines[i+1].X, lines[i+1].Y)
  end

  --Restore colour
  love.graphics.setColor(r,g,b,a)
end