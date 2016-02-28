local State = Class("State")
function State:Create(name)
  self.Name = name
  self.States = {}
  self.Objects = {}
  self.Camera = Renderer.Camera()
end
return State