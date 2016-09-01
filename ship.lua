local Ship = Class("Ship")

Ship.image = love.graphics.newImage("res/greenrect.png")

function Ship:create(x, y)
  self.x, self.y = x or 0, y or 0
  self.angle = 0
end

function Ship:draw()
  love.graphics.draw(self.image, self.x, self.y, self.angle, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
end

return Ship