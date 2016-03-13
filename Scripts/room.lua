Class("Room", Entity)

--Pilots the ship
Class("PilotRoom", Room)

PilotRoom.Texture = "blueRect.png"
PilotRoom.ScaleX = 5
PilotRoom.ScaleY = 3

function PilotRoom:Create()
  Scene.Add(self)
end