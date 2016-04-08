require "Engine/Scene/script"

--Add object to scene
--[[function Scene.Add(self)
  table.insert(Objects, self)
  self.Id = Network.UUID()

  --Create collider for object
  local collider = Physics.Colliders[self]
  if not collider and self.UsePhysics then Physics.Add(self) end

  --Create animation for object
  if self.Animation then Renderer.Animation(self, self.Animation, self.State, self.Loop) end
end


--Get objects of type
function Scene.GetObjects(name)
  local objects = {}
  for k,v in pairs(Objects) do
    if v:IsType(name) then table.insert(objects, v) end
  end
  return objects
end

--Get objects of type in a area
function Scene.GetObjectsInArea(name, x, y, width, height)
  local objects = {}
  for k,v in pairs(Objects) do
    if v:IsType(name) and v:InArea(x, y, width, height) then 
      table.insert(objects, v) 
    end
  end
  return objects
end

--Store last position of object
v.LastX, v.LastY, v.LastAngle = v.X, v.Y, v.Angle

--Update animation
local animation = Renderer.Animations[v]
if animation then animation:Update(dt) end 

v:Update(dt)
v:Ui()

--Draw sprite
if v.Texture then Renderer.Sprite(v.Texture, v.X, v.Y, v.Angle) end

--Draw animation
local animation = Renderer.Animations[v]
if animation then animation:Draw(v) end 

v:Draw()--]]