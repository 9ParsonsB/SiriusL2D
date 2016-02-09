Bullet = Class("Bullet")

function Bullet:Create(x, y, angle)
	self.X = x
	self.Y = y
	self.Angle = angle
	self.Timer = 0
end
function Bullet:Update(dt)
	self.Timer = self.Timer + dt
	if self.Timer >= 2 then self:Destroy() end
end
function Bullet:Draw()
	Renderer.DrawSprite("greenRect.png", self.X, self.Y, self.Angle, 20, 20)
end
return Bullet