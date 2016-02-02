local Entity = require "Engine/entity"
local Sprite = require "Engine/sprite"
local Collider = require "Engine/collider"

local Bullet = require "Game/bullet"

local Player = Class.New("Player", Entity)
function Player:Create(x, y, speed)
	self.X = x or 0
	self.Y = y or 0

	self.Speed = speed or 0
	self.FireTimer = 0
	self.FireSpeed = 0.001

	self.Sprite = Sprite("greenRect.png")
	self.Collider = Collider(x, y, self.Sprite.Width, self.Sprite.Height, "dynamic")  

	local camera = self:GetCamera("Game")
	if camera then self:Attach(camera) end

	self:SetScreen("Game") 
end
function Player:Update(dt)
	--Rotate to face mouse
	self:Face(love.mouse.getX(), love.mouse.getY())

	--WASD movement
	if love.keyboard.isDown("w") then self:Accelerate(0, -self.Speed * dt) end
	if love.keyboard.isDown("s") then self:Accelerate(0, self.Speed * dt) end
	if love.keyboard.isDown("a") then self:Accelerate(-self.Speed * dt, 0) end	
	if love.keyboard.isDown("d") then self:Accelerate(self.Speed * dt, 0) end

	self:Fire(dt)
end
function Player:Fire(dt)
	self.FireTimer = self.FireTimer + dt
	if love.keyboard.isDown("space") and self.FireTimer > self.FireSpeed then
		local x, y = self:GetForward()
		Bullet(self.X, self.Y, 0, x * 500, y * 500)
		self.FireTimer = 0
	end
end
return Player