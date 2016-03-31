Class("Debug")

Debug.Enabled = true

function Debug:Create()
  Scene.Add(self)
end

function Debug:DrawUi()
  if self.Enabled then
    Ui.Label("FPS: " .. love.timer.getFPS(), self.X, self.Y, 100)
  end

  if not Scene.Active then
    local width, height = love.graphics.getDimensions()
    Ui.Label("Paused", width / 2, height - 50, 100)
  end
end

function Debug:KeyPressed(key)
  if key == "f3" then self.Enabled = not self.Enabled end
end