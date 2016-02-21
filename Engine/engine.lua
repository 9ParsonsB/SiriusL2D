local Camera = require "Engine/camera"

Engine = {}
Engine.States = {}
Engine.State = ""
Engine.Camera = Camera.New()
Engine.Objects = {}

function Engine.NewState(name)
  local self = {Objects = {}, Active = true, Visible = true}
  self.Camera = Camera.New()
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
  Engine.Fire("Update", dt)
  Engine.Fire("Sync")
  Physics.Update(dt)
end

function love.draw()
  --Regular drawing
  Engine.Camera:Set()
  Engine.Fire("Draw")
  Engine.Camera:Unset()

  --GUI drawing(Buttons etc)
  Engine.Fire("GUI")

  --Debug drawing(Variables etc)
  Engine.Fire("Debug")
 
  Engine.LeftPressed = false
end

function love.keypressed(key)
  Engine.Fire("KeyPressed", key)
end
function love.keyreleased(key)
  Engine.Fire("KeyReleased", key)
end

function love.mousepressed(x, y, button, istouch)
  Engine.Fire("MousePressed",  x, y, button, isTouch)

  if button == 1 then Engine.LeftPressed = true end
end
function love.mousemeleased(x, y, button)
  Engine.Fire("MouseReleased", x, y, button)
end
function love.mousemoved(x, y, dx, dy)
  Engine.Fire("MouseMoved", x, y, dx, dy)
end