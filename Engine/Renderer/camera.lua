Camera = {}

Camera.X, Camera.Y = 0, 0
Camera.ScaleX, Camera.ScaleY = 1, 1

function Camera:Set()
  local width, height = love.graphics.getDimensions()
  love.graphics.push()
  love.graphics.scale(1 / self.ScaleX, 1 / self.ScaleY)
  love.graphics.translate(-self.X + width / 2, -self.Y + height / 2)

  --[[love.graphics.push()
  love.graphics.scale(1 / self.ScaleX, 1 / self.ScaleY)
  love.graphics.translate(-self.X , -self.Y)--]]
end

function Camera:Unset()
  love.graphics.pop()
end

function Camera:Scale(x, y)
  self.ScaleX = self.ScaleX + x
  self.ScaleY = self.ScaleY + y
end

function Camera:SetPosition(x, y)
  self.X, self.Y = x, y
end

function Camera:Move(x, y)
  self.X, self.Y = self.X + (x or 0), self.Y + (y or 0)
end

function Camera:GetMousePosition()
  local width, height = love.graphics.getDimensions()
  local x, y = love.mouse.getPosition()
  return (self.X + x) - width / 2, (self.Y + y) - height / 2

  --[[local x, y = love.mouse.getPosition()
  return self.X + x, self.Y + y--]]
end

--Overridable camera functions
function Camera:Create() end
function Camera:Update(dt) end

function Camera:KeyPressed(key) end
function Camera:KeyReleased(key) end

function Camera:MousePressed(x, y, button, isTouch) end
function Camera:MouseReleased(x, y, button, isTouch) end
function Camera:MouseMoved(x, y, dx, dy) end
function Camera:WheelMoved(x, y) end