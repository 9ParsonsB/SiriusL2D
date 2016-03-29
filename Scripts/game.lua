Map = Transform.Grid(200, 200, 30, 20)
Map.ShowLines = true

function Draw(self)
  Map:Draw()
end

function DrawUi(self)
  Ui.Label("FPS: " .. love.timer.getFPS(), 0, 0, 100)

  local x, y = Scene.Camera:GetMousePosition()
  Ui.Label(string.format("Mouse position: X: %i, Y: %i", x, y), 0, 20, 100)
end

function MousePressed(self, x, y, button, isTouch)
  if button == 2 then Map:Toggle(Scene.Camera:GetMousePosition()) end
end

function KeyPressed(self, key)
  if key == "escape" then love.event.quit() end
  if key == "1" then Map.ShowLines = not Map.ShowLines end
  if key == "2" then Map.Debug = not Map.Debug end
end