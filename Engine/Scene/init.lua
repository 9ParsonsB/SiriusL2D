require "Engine/Scene/script"
require "Engine/Scene/camera"

local GameObject = require "Engine/Scene/gameObject"

Scene = {
  Objects = {}
}

--Callback method on all objects
function Scene.Callback(name, ...)
  for k,v in pairs(Scene.Objects) do v[name](v, ...)  end
end

--Add object to scene
function Scene.Add(self)
  table.insert(Scene.Objects, self)
  self.Id = #Scene.Objects
end

--Remove object froms scene
function Scene.Destroy(self)
  Scene.Objects[self.Id] = nil
end

--Get objects of type
function Scene.GetObjects(name)
  local objects = {}
  for k,v in pairs(Scene.Objects) do
    if v:IsType(name) then table.insert(objects, v) end
  end
  return objects
end

--Get objects of type in a area
function Scene.GetObjectsInArea(name, x, y, width, height)
  local objects = {}
  for k,v in pairs(Scene.Objects) do
    if v:IsType(name) and v:Contains(x, y) then table.insert(objects, v) end
  end
  return objects
end

--Update objects in scene
function Scene.Update(dt)
  for k,v in pairs(Scene.Objects) do Scene.UpdateObject(v, dt) end
  Scene.Callback("Update", dt)
  Scene.Callback("Ui", dt)
end

--Update object
function Scene.UpdateObject(self, dt)
  self.LastX, self.LastY, self.LastAngle = self.X, self.Y, self.Angle
  if self.Animation then Renderer.UpdateAnimation(self, dt) end    

  local collider = Physics.Colliders[self]
  if not collider and self.UsePhysics then Physics.Add(self) end
end

--Draw objects in scene
function Scene.Draw()	
  for k,v in pairs(Scene.Objects) do
    if v.Texture then Renderer.Sprite(v.Texture, v.X, v.Y, v.Angle) end
    if v.Animation then Renderer.DrawAnimation(v) end 
    v:Draw()
  end
end
return Scene