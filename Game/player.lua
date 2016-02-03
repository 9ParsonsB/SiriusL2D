local Entity = require "Engine/entity"
local Renderer = require "Engine/renderer"
local Collider = require "Engine/collider"
local Bullet = require "Game/bullet"

local Player = Class.New("Player", Entity)
function Player:Create(x, y, speed)
	Entity.Create(self, x, y)
	self.Speed = speed or 0
	self.FireTimer = 0
	self.FireSpeed = 0.001
	
	self.Collider = Collider(x, y, 50, 50, "dynamic")
	--local camera = self:GetCamera("Game")
	--if camera then self:Attach(camera) end

	self:SetScreen("Game") 
end
function Player:Update(dt)
	self:SetVelocity(self.Collider:GetVelocity())

	--Rotate to face mouse
	self:Face(love.mouse.getX(), love.mouse.getY())

	--WASD movement
	if love.keyboard.isDown("w") then self:Accelerate(0, -self.Speed * dt) end
	if love.keyboard.isDown("s") then self:Accelerate(0, self.Speed * dt) end
	if love.keyboard.isDown("a") then self:Accelerate(-self.Speed * dt, 0) end	
	if love.keyboard.isDown("d") then self:Accelerate(self.Speed * dt, 0) end

	--[[self.FireTimer = self.FireTimer + dt
	if love.keyboard.isDown("space") and self.FireTimer > self.FireSpeed then
		local x, y = self:GetForward()
		Bullet(self.X, self.Y, 0, x * 500, y * 500)
		self.FireTimer = 0
	end--]]
end
function Player:Draw()
	Renderer.DrawSprite("greenRect.png", self.X, self.Y, self.Angle)
end
function Player:Accelerate(x, y)
	Entity.Accelerate(self, x, y)
	self.Collider:Accelerate(x, y)
end
return Player