-- View = class("Camera")

-- function View:create(x, y)
--   self.x, self.y = x or 0, y or 0
-- end

-- function View:push()
--   local w, h = love.graphics.getDimensions()
--   love.graphics.push()
--   -- love.graphics.translate(-self.x + (w / 2), -self.y + (h / 2))
-- end

-- function View:pop()
--   love.graphics.pop()
-- end

-- function View:move(x, y)
--   self.x, self.y = self.x + x, self.y + y
-- end

-- function View:getMousePosition()
--   local w, h = love.graphics.getDimensions()
--   local x, y = love.mouse.getPosition()
--   return (self.x + x) - w / 2, (self.y + y) - h / 2
-- end

function love.graphics.setCamera(x, y)
  local w, h = love.graphics.getDimensions()
  love.graphics.push()
  love.graphics.translate(-x + (w / 2), -y + (h / 2))
end

function love.graphics.resetCamera()
  love.graphics.pop()
end

function love.graphics.setViewport(x, y, w, h, sw, sh)
  sw, sh = sw or love.graphics.getWidth(), sh or love.graphics.getHeight()
  love.graphics.push()
  love.graphics.translate(x, y)
  love.graphics.scale(w / sw, h / sh)
  love.graphics.setScissor(x, y, w, h)
end

function love.graphics.resetViewport()
  love.graphics.pop()
  love.graphics.setScissor()
end
