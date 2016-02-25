--Add engine to package path
--package.path = package.path .. "./Engine/?.lua;"

--Load base files
require "Engine/class"
require "Engine/object"
require "Engine/Physics/physics"
require "Engine/Renderer/renderer"
require "Engine/Network/network"
require "Engine/UI/core"

Engine = {}

Engine.States = {}
Engine.State = ""
Engine.Camera = Renderer.Camera()
Engine.Objects = {}

Engine.Client = Network.Client('TEMPCLIENT1')
Engine.Server = Network.Server('TEMPSERVER1')

function Engine.NewState(name)
  local self = {Objects = {}, Active = true, Visible = true}
  self.Camera = Renderer.Camera()
  Engine.States[name] = self
  return self
end

function Engine.Add(object, name)
  if name then
    local state = Engine.GetState(name)
    table.insert(state.Objects, object)
  else
    table.insert(Engine.Objects, object)
  end
end

--Get state
--Creates a new one if none exists
function Engine.GetState(name)
  return Engine.States[name] or Engine.NewState(name)
end

function Engine.SetState(name)
  --Set current state variables
  local state = Engine.GetState(name)
  Engine.Camera = state.Camera
  Engine.Objects = state.Objects
  Engine.State = name
end

function Engine.HasState(state)
  if Engine.States[state] then return true end
  return false
end

--Runs function for all objects
function Engine.Fire(trigger, ...)
  for k,v in pairs(Engine.Objects) do
    if type(v[trigger]) == "function" then
      v[trigger](v, ...)
    end
  end
end

function love.update(dt)
  --Update objects
  Engine.Fire("Update", dt)
  Engine.Fire("Sync")

  --Update physics simulation
  Physics.Update(dt)

  --Update ui
  Ui.Update(dt)

  --Update server if its created
  if Engine.Server.Running then Engine.Server:Update() end
  if Engine.Client.Running then Engine.Client:Update() end
end

function love.draw()
  --Regular drawing
  Engine.Camera:Set()
  Engine.Fire("Draw")
  Engine.Camera:Unset()

  --Draw ui
  Ui.Draw()

  --Debugging
  Engine.Fire("Debug")
  Engine.Client:Debug()
  if Engine.Server.Intergrated then Engine.Server:Debug() end
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

--Love callbacks
function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end 
  love.graphics.setBackgroundColor(104, 136, 248)
  love.physics.setMeter(64)
end

function love.keypressed(key)
  Engine.Fire("KeyPressed", key)
  Ui.KeyPressed(key)
end

function love.keyreleased(key)
  Engine.Fire("KeyReleased", key)
end

function love.mousepressed(x, y, button, istouch)
  Engine.Fire("MousePressed",  x, y, button, isTouch)
  Ui.MousePressed(x, y, button, isTouch)
end

function love.mousereleased(x, y, button)
  Engine.Fire("MouseReleased", x, y, button)
end

function love.mousemoved(x, y, dx, dy)
  Engine.Fire("MouseMoved", x, y, dx, dy)
end

function love.textinput(t)
  Engine.Fire("TextInput", t)
end