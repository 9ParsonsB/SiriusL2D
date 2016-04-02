Object = Class("Object")

Object.X, Object.Y = 0, 0
Object.Angle = 0

function Object:Create(x, y)
  Scene.Add(self)
end

function Object:Attach(object)
  object.Parent = self
end