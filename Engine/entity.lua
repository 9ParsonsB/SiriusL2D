local GameState = require "Engine/gameState"

local Entity = Class.New("Entity")

Entity.X = 0
Entity.Y = 0
Entity.VelX = 0
Entity.VelY = 0
Entity.Angle = 0
Entity.Attached = {}
Entity.AttachedCount = 0

function Entity:Create(x, y, angle, velX, velY)
	self.X = x or 0
	self.Y = y or 0
	self.Angle = angle or 0
	self.VelX = velX or 0
	self.VelY = velY or 0
end

function Entity:Update() end
function Entity:Draw() end

function Entity:Destroy()
	GameState:Destroy(self)
end

function Entity:Attach(entity)
	--Prevents attaching to itself
	if entity ~= self then
		self.Attached[self.AttachedCount] = entity
		self.AttachedCount = self.AttachedCount + 1
	end
end

function Entity:GetCamera(screen)
	if GameState.Screens[screen] then
		return GameState.Screens[screen].Camera
	end
end

function Entity:SetScreen(screen)
	GameState:SetScreen(self, screen)
	for k,v in pairs(self.Attached) do GameState:SetScreen(v, screen) end
end

function Entity:SetPosition(x, y)
	self.X = x or self.X
	self.Y = y or self.Y
	for k, v in pairs(self.Attached) do v:Move(x - v.X, y - v.Y) end
end

function Entity:SetVelocity(x, y)
	self.VelX = x
	self.VelY = y

	if self.Collider then self.Collider:SetVelocity(x, y) end

	for k, v in pairs(self.Attached) do v:Accelerate(x - v.VelX, y - v.VelY) end
end

function Entity:Accelerate(x, y)
	self.VelX = self.VelX + x
	self.VelY = self.VelY + y

	if self.Collider then self.Collider:Accelerate(x, y) end

	for k, v in pairs(self.Attached) do v:Accelerate(x, y) end
end

function Entity:Move(x, y)
	self.X = self.X + x
	self.Y = self.Y + y
	for k, v in pairs(self.Attached) do v:Move(x, y) end
end

--Sets the angle of the entity to face the target point
function Entity:Face(targetX, targetY)
	self:SetAngle(-self.AngleToPoint(self.X, self.Y, targetX, targetY))
end

function Entity:GetForward()
	local angleRad = (math.pi / 180) * (self.Angle + 90)
	return math.cos(angleRad), math.sin(angleRad)
end

function Entity:SetAngle(angle)
	self.Angle = angle
	for k, v in pairs(self.Attached) do v:Rotate(angle - v.Angle) end
end

function Entity:Rotate(degrees)
	self.Angle = self.Angle + degrees
	for k, v in pairs(self.Attached) do v:Rotate(degrees) end
end

--Gets angle from 2 points
function Entity.AngleToPoint(x1, y1, x2, y2) 
	return math.atan2(x2-x1, y2-y1) * (180 / math.pi)
end
return Entity