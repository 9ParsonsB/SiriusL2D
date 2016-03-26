Renderer = {
  ContentDir = "Content/", 
  Textures = {},
  R,G,B,A = 0, 0, 0, 0
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

--Set colour for rendering
function Renderer.SetColour(colour)
  colour = colour or {255, 255, 255}
  Renderer.R, Renderer.G, Renderer.B, Renderer.A = love.graphics.getColor()
  love.graphics.setColor(colour)
end

--Reset colour to what it was
function Renderer.ResetColour()
  love.graphics.setColor(Renderer.R, Renderer.G, Renderer.B, Renderer.A)
end

--Draw box
function Renderer.Box(x, y, width, height, colour)
  Renderer.SetColour(colour)
  love.graphics.rectangle("fill", x, y, width, height)
  Renderer.ResetColour()
end

--Draw line
function Renderer.Line(x1, y1, x2, y2, colour)
  Renderer.SetColour(colour)
  love.graphics.line(x1, y1, x2, y2)
  Renderer.ResetColour()
end

--Draw table of lines
function Renderer.Lines(lines, colour)
  Renderer.SetColour(colour)
  for i=1, #lines-1 do love.graphics.line(lines[i].X, lines[i].Y, lines[i+1].X, lines[i+1].Y) end
  Renderer.ResetColour()
end