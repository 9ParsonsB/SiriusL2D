local Entity = require "Engine/entity"

local Ship = Class.New("Ship", Entity)
function Ship:Create(x, y, angle)
	self.X = x
	self.Y = y
	self.Angle = angle
	self:SetScreen("Game")
end
return Ship