Class("Game")

Game.X = 0
Game.Y = 0
Game.DebugMode = true

function Game:Create()
  Engine.Add(self, "Game")
end

function Game:Debug()
  if not self.DebugMode then return end

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

function Game:KeyPressed(key)
  if key == "escape" then Engine.SetState("MainMenu") end
  
  if key == "1" then Physics.Debug = not Physics.Debug end
  if key == "2" then Physics.Active = not Physics.Active end
  if key == "3" then self.DebugMode = not self.DebugMode end
end