local Sprite = Class("Sprite")

Sprite.OriginX = 0
Sprite.OriginY = 0
Sprite.ScaleX = 1
Sprite.ScaleY = 1

function Sprite:Create(texture, x, y, angle)
  self.Texture = Renderer.GetTexture(texture)
  self.Width = self.Texture:getWidth()
  self.Height = self.Texture:getHeight()

  self.X = x or 0
  self.Y = y or 0
  self.Angle = angle or 0

  self:Center()
end
function Sprite:Center()
  --Get texture size
  local tWidth, tHeight = self.Texture:getDimensions()

  self.OriginX = tWidth / 2
  self.OriginY = tHeight / 2 
end
function Sprite:SetSize(width, height)
  --Get texture size
  local tWidth, tHeight = self.Texture:getDimensions()

  --Calculate new scale
  self.ScaleX = width / tWidth
  self.ScaleY = height / tHeight

  --Store new size
  self.Width, self.Height = width, height
end
function Sprite:SetWidth(width)
  --Get texture size
  local tWidth = self.Texture:getWidth()

  --Calculate new scale
  self.ScaleX = width / tWidth

  --Store new width
  self.Width = width
end
function Sprite:SetHeight(height)
  --Get texture size
  local tHeight = self.Texture:getWidth()

  --Calculate new scale
  self.ScaleY = height / tHeight

  --Store new width
  self.Height = height
end
function Sprite:Draw(x, y, angle)
  x, y = x or 0, y or 0
  angle = angle or 0

  love.graphics.draw(
	self.Texture, 
	self.X + x, self.Y + y, 
	(math.pi / 180) * (self.Angle + angle), 
	self.ScaleX, self.ScaleY, 
	self.OriginX, self.OriginY)
end
return Sprite