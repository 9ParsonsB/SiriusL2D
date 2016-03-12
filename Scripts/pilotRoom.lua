Class("PilotRoom", Room)

PilotRoom.Texture = "blueRect.png"

function PilotRoom:Create(x, y)
  self:SetPosition(x, y)
  Scene.Add(self)
end