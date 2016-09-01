local Player = Class("Player")

Player.image = love.graphics.newImage("res/greenrect.png")

function Player:create(x, y)
  self.x, self.y = x or 0, y or 0
  self.angle = 0
end

function Player:update(dt)
  local s = 500 * dt
  if love.keyboard.isDown("w") then self.y = self.y - s end
  if love.keyboard.isDown("a") then self.x = self.x - s end
  if love.keyboard.isDown("s") then self.y = self.y + s end
  if love.keyboard.isDown("d") then self.x = self.x + s end
end

function Player:mousemoved(x, y, dx, dy)
  --local x, y = camera.getMousePosition()
  self.angle = math.atan2(y - self.y, x - self.x)
end

function Player:draw()
  love.graphics.draw(self.image, self.x, self.y, self.angle, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
end

function Player:ui()
  love.graphics.print("FPS: " .. love.timer.getFPS(), 0, 0)
  love.graphics.print("Player X: " .. self.x .. "  Y:" .. self.y, 0, 20)
end

return Player