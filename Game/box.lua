function Create()
  SetCollider("static", "box", 500, 50)
  State.Add(self, "Game")
end

function Draw()
  DrawSprite("greenRect.png", X, Y, Angle, 500, 50)
  if Physics.Debug then DrawCollider() end
end