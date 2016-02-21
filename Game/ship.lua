Speed = 300

Class("Ship", "Entity")

function Ship:Create(x, y)
  self.X, self.Y = x or 0, y or 0
  self.PilotSeat = NewObject("PilotSeat", self, x, y)
  Engine.Add(self, "Game")
end

function Ship:Update(dt)
  if self.Pilot then 
  	self.Pilot:SetPosition(self.X, self.Y) 
  	self.Pilot:SetLinearVelocity(0, 0)

  	--WASD movement controls
	--[[if love.keyboard.isDown("w") then self.Y = self.Y - Speed * dt end
	if love.keyboard.isDown("a") then self.X = self.X - Speed * dt end
	if love.keyboard.isDown("s") then self.Y = self.Y + Speed * dt end
	if love.keyboard.isDown("d") then self.X = self.X + Speed * dt end--]]
  end
end

function Ship:SetPilot(player)
  self.Pilot = player
end