function Create()
  SetCollider({Shape="box", Width = 50, Height = 50})
  State.Add(self, "Game")
end
function Draw()
  DrawSprite("greenRect.png", X, Y, Angle, 50, 50)
  DrawCollider()
end