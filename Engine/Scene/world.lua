local World = {}
local Objects = {}

function World.Add(object)
  table.insert(Objects, object)
end

function World.GetObjectMatch(object)
  for k,v in pairs(Objects) do
  	if object.Id == v.Id then return v end 
  end
end

function World.Sync(objects) 
  for k,v in pairs(objects) do
   	local object = World.GetObjectMatch(v)
   	if object then object:Sync(v) end      
  end
end

function World.Update(dt) 
  for k,v in pairs(Objects) do 

	--Store last position of object
	v.LastX, v.LastY, v.LastAngle = v.X, v.Y, v.Angle

  	--Update animation
    local animation = Renderer.Animations[v]
    if animation then animation:Update(dt) end 

  	v:Update(dt) 
  	v:Ui(dt)
  end
end

function World.Draw() 
  for k,v in pairs(Objects) do 

	--Draw sprite
	if v.Texture then Renderer.Sprite(v.Texture, v.X, v.Y, v.Angle) end

	--Draw animation
	local animation = Renderer.Animations[v]
	if animation then animation:Draw(v) end 

  	v:Draw() 
  end
end

function World.KeyPressed(key) 
  for k,v in pairs(Objects) do v:KeyPressed(key) end
end

function World.KeyReleased(key) 
 for k,v in pairs(Objects) do v:KeyReleased(key) end
end

function World.MousePressed(x, y, button, isTouch) 
  for k,v in pairs(Objects) do v:MousePressed(x, y, button, isTouch) end
end

function World.MouseReleased(x, y, button, isTouch) 
  for k,v in pairs(Objects) do v:MouseReleased(x, y, button, isTouch) end
end

function World.MouseMoved(x, y, dx, dy) 
  for k,v in pairs(Objects) do v:MouseMoved(x, y, dx, dy) end
end

function World.WheelMoved(x, y)
  for k,v in pairs(Objects) do v:WheelMoved(x, y) end
end
return World