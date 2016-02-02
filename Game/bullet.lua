local Entity = require "Engine/entity"
local Renderer = require "Engine/renderer"

local Bullet = Class.New("Bullet", Entity)
function Bullet:Create(x, y, angle, velX, velY)
	self.X = x or 0
	self.Y = y or 0
	self.Angle = angle or 0
	self.VelX = velX
	self.VelY = velY

	self.Timer = 0
	self:SetScreen("Game")
end
function Bullet:Update(dt)
	self.Timer = self.Timer + dt
	if self.Timer >= 2 then self:Destroy() end
end
function Bullet:Draw()
	Renderer.DrawSprite("greenRect.png", self.X, self.Y, self.Angle, 20, 20)
end
return Bullet