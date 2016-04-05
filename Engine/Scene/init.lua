require "Engine/Scene/script"
require "Engine/Scene/camera"

local GameObject = require "Engine/Scene/gameObject"

Scene = {
  Objects = {}
}

--Callback method on all objects
function Scene.Callback(name, ...)
  for k,v in pairs(Scene.Objects) do 
  	if type(v[name]) == "function" then v[name](v, ...) end 
  end
end

--Add object to scene
function Scene.Add(self)
  table.insert(Scene.Objects, self)
  self.Id = #Scene.Objects
  if self.Physics then Physics.Add(self) end 
end

--Remove object froms scene
function Scene.Destroy(self)
  Scene.Objects[self.Id] = nil
end

--Update objects in scene
function Scene.Update(dt)
  for k,v in pairs(Scene.Objects) do 
    if v.Active then 
      v.LastX, v.LastY, v.LastAngle = v.X, v.Y, v.Angle
      if v.Animation then Renderer.UpdateAnimation(v, dt) end    
      v:Update(dt)
      v:Ui(dt)
    end
  end
end

--Draw objects in scene
function Scene.Draw()	
  for k,v in pairs(Scene.Objects) do
    if v.Texture then Renderer.DrawSprite(v.Texture, v.X, v.Y, v.Angle) end
    if v.Animation then Renderer.DrawAnimation(v) end 
  end
end
return Scene