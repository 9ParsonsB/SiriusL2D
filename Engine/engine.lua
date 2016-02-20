local Camera = require "Engine/camera"

Engine = {}
Engine.States = {}
Engine.State = ""
Engine.Camera = Camera.New()
Engine.Objects = {}

function Engine.NewState(name)
  local self = {Objects = {}, Count = 0, Active = true, Visible = true}
  self.Camera = Camera.New()
  Engine.States[name] = self
  return self
end

function Engine.Add(object, name)
  local state = Engine.GetState(name)
  state.Objects[state.Count] = object
  state.Count = state.Count + 1
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

function Engine.Update(dt)
  Engine.Fire("Update", dt)
  Engine.Fire("Sync")
  Physics.Update(dt)
end

function Engine.Draw()
  --Regular drawing
  Engine.Camera:Set()
  Engine.Fire("Draw")
  Engine.Camera:Unset()

  --GUI drawing(Buttons etc)
  Engine.Fire("GUI")

  --Debug drawing(Variables etc)
  Engine.Fire("Debug")
end

function Engine.KeyPressed(key)
  Engine.Fire("KeyPressed", key)
end
function Engine.KeyReleased(key)
  Engine.Fire("KeyReleased", key)
end

function Engine.MousePressed(x, y, button, istouch)
  Engine.Fire("MousePressed",  x, y, button, isTouch)
end
function Engine.MouseReleased(x, y, button)
  Engine.Fire("MouseReleased", x, y, button)
end