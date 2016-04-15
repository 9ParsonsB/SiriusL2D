require "Engine/Scene/script"

local Objects = {}
local Indexes = setmetatable({}, {__mode="k"})

Scene = {}

function Scene.Add(object)
  table.insert(Objects, object)
  Indexes[object] = #Objects
end

function Scene.Remove(object)
  local index = Indexes[object]
  local last = Objects[#Objects]

  Objects[index] = last
  Indexes[last] = index

  table.remove(Objects)
end

function Scene.GetObjectMatch(object)
  for k,v in pairs(Objects) do
    if object.Id == v.Id then return v end 
  end
end

--Sync object if a match is found, else add it to scene
function Scene.Sync(objects) 
  for k,v in pairs(objects) do
    local object = Scene.GetObjectMatch(v)
    if object then object:Sync(v)    
    else Scene.Add(v) end
  end
end

function Scene.Update(dt) 
  for k,v in pairs(Objects) do 

    --Update animation
    local animation = Renderer.Animations[v]
    if animation then animation:Update(dt) end 

    v:Update(dt) 
    v:Ui(dt)
  end
end

function Scene.Draw() 
  for k,v in pairs(Objects) do 

    --Set shader
    if v.Shader then love.graphics.setShader(v.Shader) end 

    --Draw
    if v.Texture then Renderer.Sprite(v.Texture, v.Position.X, v.Position.Y, v.Angle, v.Width, v.Height) end
    local animation = Renderer.Animations[v]
    if animation then animation:Draw(v) end 
    v:Draw() 

    --Clear shader
    love.graphics.setShader()
  end
end

function Scene.KeyPressed(key) 
  for k,v in pairs(Objects) do v:KeyPressed(key) end
end

function Scene.KeyReleased(key) 
 for k,v in pairs(Objects) do v:KeyReleased(key) end
end

function Scene.MousePressed(x, y, button, isTouch) 
  for k,v in pairs(Objects) do v:MousePressed(x, y, button, isTouch) end
end

function Scene.MouseReleased(x, y, button, isTouch) 
  for k,v in pairs(Objects) do v:MouseReleased(x, y, button, isTouch) end
end

function Scene.MouseMoved(x, y, dx, dy) 
  for k,v in pairs(Objects) do v:MouseMoved(x, y, dx, dy) end
end

function Scene.WheelMoved(x, y)
  for k,v in pairs(Objects) do v:WheelMoved(x, y) end
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
function Scene.GetObjectsInArea(name, x, y, x2, y2)
  local objects = {}
  for k,v in pairs(Objects) do
    if v:IsType(name) and v:InArea(x, y, x2, y2) then 
      table.insert(objects, v) 
    end
  end
  return objects
end