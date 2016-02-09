local Camera = Class.New("Camera")
function Camera:Create(x, y)
	self.X = x
	self.Y = y
end
function Camera:Set()
	love.graphics.push()
	love.graphics.translate(-self.X, -self.Y)
end
function Camera:Unset()
  love.graphics.pop()
end
function Camera:GetMousePosition()
	return self:GetMouseX(), self:GetMouseY()
end
function Camera:GetMouseX()
	return self.X + love.mouse.getX()
end
function Camera:GetMouseY()
	return self.Y + love.mouse.getY()
end
return Camera