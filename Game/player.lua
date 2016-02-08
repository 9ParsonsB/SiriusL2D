Speed = 300

function Create(self, x, y)
	self.X = x
	self.Y = y
	self.Body = love.physics.newBody(World, x + 8, y + 8, "dynamic")
	--self.Body:setFixedRotation(true)
	self.Shape = love.physics.newRectangleShape(16, 16)
	self.Fixture = love.physics.newFixture(self.Body, self.Shape)
	self.Fixture:setUserData(self)

	self.Bounces = 0
end
function Update(self, dt)
	if self.Bounces > 5 then
		--[[self.Body:setPosition(400, 0)
		self.X = 400
		self.Y = 0--]]
		self.Bounces = 0
	end

	local x, y = self:GetLinearVelocity()

	--WASD movement
	if love.keyboard.isDown("w") then y = y - Speed * 10 * dt end
	if love.keyboard.isDown("s") then y = y + Speed * dt end
	if love.keyboard.isDown("a") then x = x - Speed * dt end	
	if love.keyboard.isDown("d") then x = x + Speed * dt end

	--Update velocity
	self:SetLinearVelocity(x, y)
end
function Draw(self)
	--Renderer.DrawSprite(self, "greenRect.png")
  	love.graphics.polygon("fill", self.Body:getWorldPoints(self.Shape:getPoints()))
end
function CollisionEnter(self, other, coll)
	self.Bounces = self.Bounces + 1
end
function CollisionExit(self, other, coll)
	--print("Collision exit")
end