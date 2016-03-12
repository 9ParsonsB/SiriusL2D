local State = require "Engine/Scene/state"

Scene = {
  States = {}
}

function Scene.GetState(name)
  --Return exisiting state
  local state = Scene.States[name]
  if state then return state end

  --Create new state 
  Scene.States[name] = State()
  return Scene.States[name]
end

function Scene.SetState(name)
  local state = Scene.GetState(name)
  Scene.State = state or Scene.State
  Scene.Name = name
  Scene.Objects = state.Objects
  Scene.Camera = state.Camera
end

function Scene.Add(object, name)
  if name then
    local state = Scene.GetState(name)
    state:Add(object)
  else
    Scene.State:Add(object)
  end
end

function Scene.Remove(object, name)
  if name then
    Scene.GetState(name):Remove(object)
  else
    Scene.State:Remove(object)
  end
end

function Scene.Update(dt)
  for k,v in pairs(Scene.Objects) do 
    if type(v.Update) == "function" then v:Update(dt) end
  end
end

function Scene.Draw()
  Scene.Camera:Set()

  for k,v in pairs(Scene.Objects) do 
    if type(v.Draw) == "function" then v:Draw() end
  end

  Scene.Camera:Unset()
end

function Scene.KeyPressed(key)
  for k,v in pairs(Scene.Objects) do 
    if type(v.KeyPressed) == "function" then v:KeyPressed(key) end
  end
end

function Scene.KeyReleased(key)
  for k,v in pairs(Scene.Objects) do 
    if type(v.KeyReleased) == "function" then v:KeyReleased(key) end
  end
end

function Scene.MousePressed(x, y, button, isTouch)
  for k,v in pairs(Scene.Objects) do 
    if type(v.MousePressed) == "function" then v:MousePressed(x, y, button, isTouch) end
  end
end

function Scene.MouseReleased(x, y, button)
  for k,v in pairs(Scene.Objects) do 
    if type(v.MouseReleased) == "function" then v:MouseReleased(x, y, button) end
  end
end

function Scene.MouseMoved(x, y, dx, dy)
  for k,v in pairs(Scene.Objects) do 
    if type(v.MouseMoved) == "function" then v:MouseMoved(x, y, dx, dy) end
  end
end

function Scene.TextInput(t)
  for k,v in pairs(Scene.Objects) do 
    if type(v.TextInput) == "function" then v:TextInput(t) end
  end
end
Scene.SetState("default")