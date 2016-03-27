function Create(self)
  self.Path = {}
  self.Speed = 300
end

function MousePressed(self, x, y, button, isTouch)
  if button == 1 then self.Path = Scripts.Path.Find(self.X, self.Y, x, y) end
end

function Update(self, dt)
  Transform.FollowPath(self, self.Path, self.Speed)
end

function Draw(self)
  love.graphics.print("PATH SIZE: " .. #self.Path, 500, 0)

  --Draw the current path
  if #self.Path > 0 then
    Renderer.Line(self.X, self.Y, self.Path[1].X, self.Path[1].Y, {0, 0, 0})
    Renderer.Lines(self.Path, {0, 0, 0})
  end
end