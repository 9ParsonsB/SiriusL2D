require "Engine/Scene/vector"

local Transform = Class("Transform")

Transform.X, Transform.Y = 0, 0
Transform.LastX, Transform.LastY = 0, 0
Transform.Angle = 0
Transform.LastAngle = 0

function Transform:Attach(object) 
  object.Parent = self 
end

function Transform:MoveTo(x, y)
	
end
return Transform