local Entity = require "Engine/entity"
local Collider = require "Engine/collider"
local Renderer = require "Engine/renderer"
local Events = require "Engine/events"

local Player = Class.New("Player", Entity)

Player.FireTimer = 0
Player.FireSpeed = 0.0001
Player.Speed = 300

function Player:Create(x, y)
	Entity.Create(self, x, y)
	self.Collider = Collider(x, y, 16, 16, "dynamic")
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

	--Shooting
	self.FireTimer = self.FireTimer + dt
	if love.keyboard.isDown("space") and self.FireTimer > self.FireSpeed then 
		Events.Fire("PlayerFired", self)
		self.FireTimer = 0
	end
end
function Player:Draw()
	Renderer.DrawSprite("greenRect.png", self.X, self.Y, self.Angle)
end
return Player