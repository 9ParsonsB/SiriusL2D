Class("Game")

Game.X = 0
Game.Y = 0
Game.DebugMode = true

function Game:Create()
  Scene.Add(self)
end

function Game:KeyPressed(key)
  if key == "f3" then self.DebugMode = not self.DebugMode end
  if key == "space" then Physics.Active = not Physics.Active end
end

function Game:Ui()
  self:Debug()
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

  --Local position of mouse
  local x, y = love.mouse.getPosition()
  love.graphics.print("Screen pos: X:" .. x .. " Y:" .. y, self.X, self.Y + 60)

  --World position mouse
  local x, y = Scene.Camera:GetMousePosition()
  love.graphics.print("World pos: X:" .. x .. " Y:" .. y, self.X, self.Y + 75)

  if not Physics.Active then
    Ui.Label("Paused", 800, 850, 100, 20)
  end
end