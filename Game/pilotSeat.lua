Class("PilotSeat", "Entity")

function PilotSeat:Create(ship, x, y)
  self:SetPosition(x, y)
  self:SetCollider("kinematic", "box", 50, 50)
  self:SetSensor(true)
  self.Ship = ship

  Engine.Add(self, "Game")
end

function PilotSeat:Draw()
  Renderer.DrawSprite("greenRect.png", self.X, self.Y, 0, 50, 50)
  if Physics.Debug then self.Collider:Draw() end
end

function PilotSeat:KeyPressed(key)
  if key == "e" then 
    --Remove current pilot
    if self.Ship.Pilot then 
      self.Ship.Pilot = nil 
      return 
    end

    --Add pilot
    if self.Player then 
      self.Ship:SetPilot(self.Player) 
    end
  end
end

function PilotSeat:CollisionEnter(object)
  if object.name == "Player" then self.Player = object end
end

function PilotSeat:CollisionExit(object)
  if object == self.Player then self.Player = nil end
end