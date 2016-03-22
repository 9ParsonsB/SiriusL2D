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