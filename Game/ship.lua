local Ship = class("Ship")
function Ship:init(x, y, angle)
	self.X = x
	self.Y = y
	self.Angle = angle
	self:SetScreen("Game")
end
return Ship