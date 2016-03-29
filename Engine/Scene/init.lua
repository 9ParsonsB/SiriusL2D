require "Engine/Scene/script"
require "Engine/Scene/timer"

Scene = {
  Camera = Renderer.Camera(0, 0),
  Objects = {}
}

function Scene.Callback(name, ...)
  for k,v in pairs(Scene.Objects) do
    if type(v[name]) == "function" then v[name](v, ...) end
  end
end

function Scene.Update(dt)
  Timer.Update(dt)
  Scene.Callback("Update", dt)
  if Script.LiveEdit then Script.Reload() end
end

function Scene.Draw()	
  Scene.Camera:Set()
  Scene.Callback("Draw")
  Scene.Camera:Unset()

  Scene.Callback("DrawUi")
end