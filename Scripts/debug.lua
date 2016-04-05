Object("Debug")

function Debug:Ui()
  Ui.Label("FPS: " .. love.timer.getFPS(), self.X, self.Y, 100)

  --Render info
  local name, version, vendor, device = love.graphics.getRendererInfo()
  Ui.Label(name .. " " .. version, 0, 20)
  Ui.Label(vendor .. " " .. device, 0, 40)
end

function Debug:KeyPressed(key)
  if key == "f3" then self.Active = not self.Active end
end