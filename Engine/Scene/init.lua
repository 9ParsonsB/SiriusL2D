require "Engine/Scene/script"
require "Engine/Scene/timer"

Scene = {
  Camera = Renderer.Camera(0, 0),
  Objects = {},
  Ids = {}
}

function Scene.Callback(name, ...)
  for k,v in pairs(Scene.Objects) do 
  	if type(v[name]) == "function" then v[name](v, ...) end 
  end
end

function Scene.Add(self)
  table.insert(Scene.Objects, self)
  Scene.Ids[self] = #Scene.Objects
end

function Scene.Destroy(self)
  Scene.Objects[Scene.Ids[self]] = nil
end

function Scene.Update(dt)
  Timer.Update(dt)

  for k,v in pairs(Scene.Objects) do 
    v.X = v.X + v.VelX * dt
    v.Y = v.Y + v.VelY * dt
  end
  Scene.Callback("Update", dt)

  if Script.LiveEdit then Script.Reload() end
end

function Scene.Draw()	
  Scene.Camera:Set()
  Scene.Callback("Draw")
  Scene.Camera:Unset()

  Scene.Callback("DrawUi")
end