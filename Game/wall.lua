local Entity = require "Engine/entity"
local Collider = require "Engine/collider"

local Wall = Class.New("Wall", Entity)
function Wall:Create(x, y)
	self.X = x or 0
	self.Y = y or 0
	--self.Collider = Collider(x, y, self.Sprite.Width, self.Sprite.Height, "kinematic")   
	self:SetScreen("Game")
end
return Wall