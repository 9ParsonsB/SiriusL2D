X = 0
Y = 0

Group.Get("MainMenu"):Add(self)

function Update(dt)

end

function Draw()
  Renderer.DrawSprite("greenRect.png", X + 200, Y + 200, 0, 200, 50)
  love.graphics.print("Generic button", X + 200, Y + 200)
end