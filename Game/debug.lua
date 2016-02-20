Class("Debug")

Debug.X = 0
Debug.Y = 0
Debug.Enabled = true

function Debug:Create()
  Engine.Add(self, "Game")
end

function Debug:Debug()
  if not self.Enabled then return end

  --Frame rate
  love.graphics.print("Frame rate: " .. love.timer.getFPS(), self.X, self.Y)

  --Render info
  local name, version, vendor, device = love.graphics.getRendererInfo()
  love.graphics.print(name .. " " .. version, self.X, self.Y + 15)
  love.graphics.print(vendor .. " " .. device, self.X, self.Y + 30)

  --Memory usage
  love.graphics.print('Memory used(KB): ' .. collectgarbage('count'), self.X, self.Y + 45)

  --Physics info
  if Physics.Active then love.graphics.print("Physics: playing", self.X, self.Y + 60)
  else love.graphics.print("Physics: paused", self.X, self.Y + 60) end

  if Physics.Debug then love.graphics.print("Physics drawing: enabled", self.X, self.Y + 75)
  else love.graphics.print("Physics drawing: disabled", self.X, self.Y + 75) end
end

function Debug:KeyPressed(key)
  if key == "3" then self.Enabled = not self.Enabled end
end