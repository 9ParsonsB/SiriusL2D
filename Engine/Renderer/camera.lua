local Camera = Class("Camera")

Camera.X, Camera.Y = 0, 0

function Camera:Set()
  local width, height = love.graphics.getDimensions()

  love.graphics.push()
  --love.graphics.translate(-self.X, -self.Y)
  love.graphics.translate(-self.X + width / 2, -self.Y + height / 2)	
end

function Camera:Unset()
  love.graphics.pop()
end

function Camera:SetPosition(x, y)
  self.X, self.Y = x, y
end

function Camera:GetMousePosition()
  local width, height = love.graphics.getDimensions()
  local x, y = love.mouse.getPosition()
  return (self.X + x) - width / 2, (self.Y + y) - height / 2
end
return Camera