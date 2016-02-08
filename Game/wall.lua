function Create(self, x, y)
	self.X = x
	self.Y = y
	self.Body = love.physics.newBody(World, x + 8, y + 8, "static")
	self.Shape = love.physics.newRectangleShape(16, 16)
	self.Fixture = love.physics.newFixture(self.Body, self.Shape)
	self.Fixture:setUserData(self)
end
function Draw(self)
	--Renderer.DrawSprite(self, "greenRect.png")
	love.graphics.polygon("fill", self.Body:getWorldPoints(self.Shape:getPoints()))
end