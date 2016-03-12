Class("Room", Entity)

Room.Hull = "blueRect.png"

function Room:Draw()
  Renderer.Sprite(self.Hull, self.X, self.Y, self.Angle, 1, 1)
end