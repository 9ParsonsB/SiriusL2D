function Create()
  State.Add(self, "Debug")
end
function Draw()
  --Frame rate
  love.graphics.print("Frame rate: " .. love.timer.getFPS(), X, Y)

  --Render info
  local name, version, vendor, device = love.graphics.getRendererInfo()
  love.graphics.print(name .. " " .. version, X, Y + 15)
  love.graphics.print(vendor .. " " .. device, X, Y + 30)

  --Memory usage
  love.graphics.print('Memory used(KB): ' .. collectgarbage('count'), X, Y + 45)

  --Physics info
  if Physics.Active then love.graphics.print("Physics: playing", X, Y + 60)
  else love.graphics.print("Physics: paused", X, Y + 60) end

  if Physics.Debug then love.graphics.print("Physics drawing: enabled", X, Y + 75)
  else love.graphics.print("Physics drawing: disabled", X, Y + 75) end
end