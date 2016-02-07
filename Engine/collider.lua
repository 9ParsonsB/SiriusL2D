local Collider = Class.New("Collider")
function Collider:Create(x, y, width, height, bodyType)
	self.Body = love.physics.newBody(World, x + width / 2, y + height / 2, bodyType)
	self.Shape = love.physics.newRectangleShape(width, height)
	self.Fixture = love.physics.newFixture(self.Body, self.Shape)
end
function Collider:Move(x, y)
	local bodyX, bodyY = self.Body:getPosition()
	self.Body:setPosition(bodyX + x, bodyY + y)
end
function Collider:GetVelocity(x, y)
	return self.Body:getLinearVelocity()
end
function Collider:SetVelocity(x, y)
	self.Body:setLinearVelocity(x, y)
end
function Collider:Accelerate(x, y)
	local velX, velY = self:GetVelocity()
	self.Body:setLinearVelocity(velX + x, velY + y)
end
return Collider