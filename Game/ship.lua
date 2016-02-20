Class("Ship", "Entity")

function Ship:Create(x, y)
  self.X, self.Y = x or 0, y or 0
  self.PilotSeat = NewObject("PilotSeat", self, x, y)
  Engine.Add(self, "Game")
end

function Ship:Update()
  if self.Pilot then self.Pilot:SetPosition(self.X, self.Y) end
end

function Ship:SetPilot(player)
  self.Pilot = player
end