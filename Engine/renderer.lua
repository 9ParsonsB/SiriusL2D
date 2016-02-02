local Renderer = {}

Renderer.ContentDir = "Content/"
Renderer.Textures = {}

function Renderer.LoadTexture(filePath)
	Renderer.Textures[filePath] = love.graphics.newImage(Renderer.ContentDir .. filePath)
end

function Renderer.DrawSprite(filePath, x, y, angle, width, height)
	--Load texture if it does not exist
	if not Renderer.Textures[filePath] then Renderer.LoadTexture(filePath) end
	local texture = Renderer.Textures[filePath]
	local textureWidth, textureHeight = texture:getDimensions()

	--Set width and scale for sprite
	width = width or textureWidth
	height = height or textureHeight
	local scaleX = width / textureWidth
	local scaleY = height / textureHeight

	--Draw sprite
	love.graphics.draw(
		texture, 
		x or 0, y or 0,
		(math.pi / 180) * (angle or 0),
		scaleX, scaleY,
		textureWidth / 2, textureHeight / 2)
end
return Renderer