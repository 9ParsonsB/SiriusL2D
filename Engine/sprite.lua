local Sprite = Class.New("Sprite")
function Sprite:Create(texture, width, height)
	--Create texture
	self.Texture = love.graphics.newImage("Content/" .. texture)
	self.TextureWidth, self.TextureHeight = self.Texture:getDimensions()

	--Store size sprite will be displayed at
	self.Width = width or self.TextureWidth
	self.Height = height or self.TextureHeight

	--Set sprites origin to be the center of the texture
	self.OffsetX = self.TextureWidth / 2
	self.OffsetY = self.TextureHeight / 2
end
function Sprite:Draw(x, y, angle)
	--Calculate scale
	local scaleX = self.Width / self.TextureWidth
	local scaleY = self.Height / self.TextureHeight

	--Draw
	love.graphics.draw(
		self.Texture,
		x or 0, y or 0,
		(math.pi / 180) * (angle or 0),
		scaleX, scaleY,
		self.OffsetX, self.OffsetY)
end
return Sprite