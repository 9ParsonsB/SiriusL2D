local Wall = Class("Wall")
function Wall:init(self, x, y, width, height)
  self.X = x
  self.Y = y
  self.Body = love.physics.newBody(World, x, y, "static")
  self.Shape = love.physics.newRectangleShape(width, height)
  self.Fixture = love.physics.newFixture(self.Body, self.Shape)
  self.Fixture:setUserData(self)
end
function Wall:draw()
  --Renderer.DrawSprite(self, "greenRect.png")
  love.graphics.polygon("fill", self.Body:getWorldPoints(self.Shape:getPoints()))
end
return Wall