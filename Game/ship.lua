local Entity = require "Engine/entity"
local Sprite = require "Engine/sprite"

local Ship = Class.New("Ship", Entity)
function Ship:Create(x, y, angle)
	self.X = x
	self.Y = y
	self.Angle = angle
	self.Sprite = Sprite("greyRect.png", 200, 200)
	self:SetScreen("Game")
end
return Ship