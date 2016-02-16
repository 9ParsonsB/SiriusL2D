Class("Debug")

Debug.X = 0
Debug.Y = 0

function Debug:Create()
  State.Add(self, "Debug")
end

function Debug:Draw()
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