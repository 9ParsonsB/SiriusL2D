require "Engine/Scene/script"
require "Engine/Scene/timer"
require "Engine/Scene/object"

Scene = {
  Camera = Renderer.Camera(0, 0),
  Objects = {},
  Ids = {},
  Active = true
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

  --Reload scripts
  if Script.LiveEdit then Script.Reload() end

  --Do not update if scene is not active
  if not Scene.Active then return end

  --Apply velocity to objects
  for k,v in pairs(Scene.Objects) do 
    v.OldX, v.OldY = v.X, v.Y
    v.X, v.Y = v.X + v.VelX * dt, v.Y + v.VelY * dt

    if v.Parent then
      v.X = v.X + (v.Parent.X - v.Parent.OldX)
      v.Y = v.Y + (v.Parent.Y - v.Parent.OldY)
    end
  end
  
  Scene.Callback("Update", dt)
  Scene.Callback("Ui")
end

function Scene.Draw()	
  Scene.Camera:Set()

  --Temp
  Scene.Callback("Draw")

  --Draw objects
  for k,v in pairs(Scene.Objects) do
    if v.Texture then Renderer.Sprite(v.Texture, v.X, v.Y) end
    if v.Animation and v.State then Renderer.Animation(v, v.Animation, v.State, true) end
    if v.Path then Renderer.Path(v, v.Path, {0, 0, 0}) end
  end

  Scene.Camera:Unset()
end