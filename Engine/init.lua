--Add engine to package path
--package.path = package.path .. "./Engine/?.lua;"

--Load base files
require "Engine/core"
require "Engine/Network"
require "Engine/Physics"
require "Engine/Renderer"
require "Engine/Scene"
require "Engine/Ui"

--Love callbacks
function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end 
  love.graphics.setBackgroundColor(104, 136, 248)
  love.physics.setMeter(64)
end

function love.update(dt)
  Network.Update(dt)
  Scene.Update(dt)
  Physics.Update(dt)
  Script.Update(dt)
  Ui.Update(dt)
end

function love.draw()
  Scene.Draw()
  Ui.Draw()
end

function love.keypressed(key)
  Scene.KeyPressed(key)
end

function love.keyreleased(key)
  Scene.KeyReleased(key)
end

function love.mousepressed(x, y, button, istouch)
  Scene.MousePressed(x, y, button, isTouch)
  Ui.MousePressed(x, y, button, isTouch)
end

function love.mousereleased(x, y, button)
  Scene.MouseReleased(x, y, button)
end

function love.mousemoved(x, y, dx, dy)
  Scene.MouseMoved(x, y, dx, dy)
end

function love.textinput(t)
  Scene.TextInput(t)
end

--split string.
string.split = function (self,delimiter)
  local result = { }
  local from  = 1
  local delim_from, delim_to = string.find( self, delimiter, from  )
  while delim_from do
    table.insert( result, string.sub( self, from , delim_from-1 ) )
    from  = delim_to + 1
    delim_from, delim_to = string.find( self, delimiter, from  )
  end
  table.insert( result, string.sub( self, from  ) )
  return result
end

--[[function Game:Debug()
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

  --Local position of mouse
  local x, y = love.mouse.getPosition()
  love.graphics.print("Screen pos: X:" .. x .. " Y:" .. y, self.X, self.Y + 90)

  --World position mouse
  local x, y = Engine.Camera:GetMousePosition()
  love.graphics.print("World pos: X:" .. x .. " Y:" .. y, self.X, self.Y + 105)
end

function Game:KeyPressed(key)
  if key == "escape" then Engine.SetState("MainMenu") end
  
  if key == "1" then Physics.Debug = not Physics.Debug end
  if key == "2" then Physics.Active = not Physics.Active end
  if key == "3" then self.DebugMode = not self.DebugMode end
end--]]