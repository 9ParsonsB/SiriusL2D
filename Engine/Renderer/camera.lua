local Camera = Class("Camera")

function Camera:Create(x, y)
  self.X, self.Y = x or 0, y or 0
  self.ScreenWidth, self.ScreenHeight = love.graphics.getDimensions()
end

function Camera:Set()
  local width, height = love.graphics.getDimensions()

  love.graphics.push()
  love.graphics.translate(-self.X, -self.Y)
  love.graphics.scale(width / self.ScreenWidth, height / self.ScreenHeight)

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