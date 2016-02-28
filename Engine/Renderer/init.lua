Renderer = {
  Camera = require "Engine/Renderer/camera",
  Sprite = require "Engine/Renderer/sprite",
  ContentDir = "Content/", 
  Textures = {}
}

function Renderer.GetTexture(filePath)
  --Only load texture once
  if Renderer.Textures[filePath] then return Renderer.Textures[filePath] end

  --Load texture
  local texture = love.graphics.newImage(Renderer.ContentDir .. filePath)
  Renderer.Textures[filePath] = texture

  return texture
end