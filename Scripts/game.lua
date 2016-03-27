DebugMode = true
Paused = false
CurrentUnit = nil

function IsSelected(self)
  return self == CurrentUnit
end

function KeyPressed(self, key)
  if key == "escape" then love.event.quit() end
  if key == "space" then Paused = not Paused end
  if key == "f3" then DebugMode = not DebugMode end
end

function DrawUi(self)
  local w, h = love.graphics.getDimensions()
  if Paused then Ui.Label("Paused", (w / 2) - 50, h - 100, 100, 30) end
  if DebugMode then DrawDebug(self) end
end

function DrawDebug(self)
  --Frame rate
  Ui.Label("Frame rate: " .. love.timer.getFPS(), self.X, self.Y, 300, 20)

  --Render info
  local name, version, vendor, device = love.graphics.getRendererInfo()
  Ui.Label(name .. " " .. version, self.X, self.Y + 15, 300, 20)
  Ui.Label(vendor .. " " .. device, self.X, self.Y + 30, 300, 20)

  --Memory usage
  Ui.Label('Memory used(KB): ' .. collectgarbage('count'), self.X, self.Y + 45, 300, 20)

  --Show unit that is selected
  if CurrentUnit then
    Ui.Label(string.format("Unit X,Y: %i %i", CurrentUnit.X, CurrentUnit.Y), 0, 60, 100, 20)
  end
end