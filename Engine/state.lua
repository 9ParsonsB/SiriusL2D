local Camera = require "Engine/camera"

State = {}
local States = {}

function State.New(name)
  local self = setmetatable({Objects = {}, Count = 0, Visible = true}, {__index=State})
  self.Camera = Camera.New()
  States[name] = self
  return self
end

function State.Add(object, name)
  local state = State.Get(name)
  state.Objects[state.Count] = object
  state.Count = state.Count + 1
end

--Get camera from group
function State.GetCamera(name)
  return State.Get(name).Camera or Camera.New()
end

--Get state
--Creates a new one if none exists
function State.Get(name)
  return States[name] or State.New(name)
end

function State.Update(name, dt)
  for k,v in pairs(State.Get(name).Objects) do
    if type(v.Update) == "function" then v:Update(dt) end
    v:Sync()
  end
end

function State.Draw(name)
  local state = State.Get(name)

  --Only draw if visible
  if not state.Visible then return end

  --Apply camera settings
  local camera = state.Camera
  if camera then camera:Set() end
    
  for k,v in pairs(state.Objects) do
    if type(v.Draw) == "function" then v:Draw(dt) end
  end

  --Clear camera settings
  if camera then camera:Unset() end
end

function State.KeyPressed(name, key)
  for k,v in pairs(State.Get(name).Objects) do
    if type(v.KeyPressed) == "function" then v:KeyPressed(key) end
  end
end

function State.KeyReleased(name, key)
  for k,v in pairs(State.Get(name).Objects) do
    if type(v.KeyReleased) == "function" then v:KeyReleased(key) end
  end
end