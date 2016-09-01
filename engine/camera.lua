Camera = Class("Camera")

function Camera:create(x, y)
  self.x, self.y = x or 0, y or 0
end

function Camera:push()
  local w, h = love.graphics.getDimensions()
  love.graphics.push()
  love.graphics.translate(-self.x + (w / 2), -self.y + (h / 2))
end

function Camera:pop()
  love.graphics.pop()
end

function Camera:move(x, y)
  self.x, self.y = self.x + x, self.y + y
end

function Camera:getMousePosition()
  local w, h = love.graphics.getDimensions()
  local x, y = love.mouse.getPosition()
  return (self.X + x) - width / 2, (self.Y + y) - height / 2
end
