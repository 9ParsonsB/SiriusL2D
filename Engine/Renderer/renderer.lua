Renderer = {
  ContentDir = "Content/", 
  Textures = {},
  Camera = require "Engine/Renderer/camera"
}

function Renderer.LoadTexture(filePath)
	Renderer.Textures[filePath] = love.graphics.newImage(Renderer.ContentDir .. filePath)
end

function Renderer.DrawSprite(filePath, x, y, angle, width, height, offsetX, offsetY)
	x = x or 0
	y = y or 0
	angle = angle or 0

	--Load texture if it does not exist
	if not Renderer.Textures[filePath] then Renderer.LoadTexture(filePath) end
	local texture = Renderer.Textures[filePath]
	local textureWidth, textureHeight = texture:getDimensions()

	--Origin defaults to center
	local originX = textureWidth / 2
	local originY = textureHeight / 2

	--If origin set
	originX = offsetX or originX
	originY = offsetY or originY

	--Set width and scale for sprite
	width = width or textureWidth
	height = height or textureHeight
	local scaleX = width / textureWidth
	local scaleY = height / textureHeight

	--Draw sprite
	love.graphics.draw(
		texture, 
		x, y, 
		(math.pi / 180) * angle, 
		scaleX, scaleY, 
		originX, originY)
end

function Renderer.DrawText(value, x, y, angle)
	love.graphics.print(value, x or 0, y or 0, (math.pi / 180) * (angle or 0))
end