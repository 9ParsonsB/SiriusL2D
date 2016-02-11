function Create(angle)
  Body = love.physics.newBody(Physics.World, 400, 300, "static")
  Body:setAngle((math.pi / 180) * (angle or 0))
  Shape = love.physics.newRectangleShape(500, 10)
  Fixture = love.physics.newFixture(self.Body, self.Shape)
  Fixture:setUserData(self)
end

function Draw()
  Renderer.DrawSprite("greenRect.png", Body:getX(), Body:getY(), (180 / math.pi) * Body:getAngle(), 500, 10)
end