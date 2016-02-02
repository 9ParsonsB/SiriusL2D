local Entity = require "Engine/entity"
local Sprite = require "Engine/sprite"
local Collider = require "Engine/collider"

local Wall = Class.New("Wall", Entity)
function Wall:Create(x, y)
	self.X = x or 0
	self.Y = y or 0

	self.Sprite = Sprite("greenRect.png")
	self.Collider = Collider(x, y, self.Sprite.Width, self.Sprite.Height, "kinematic")   
	self:SetScreen("Game")
end
return Wall