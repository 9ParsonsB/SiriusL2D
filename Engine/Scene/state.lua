local State = Class("State")

function State:Create(name)
  self.Name = name
  self.Camera = Renderer.Camera()

  self.States = {}
  self.Objects = {}
  self.Ids = setmetatable({}, {__mode="k"})
end

function State:Add(object)
  table.insert(self.Objects, object)
  self.Ids[object] = #self.Objects
end

function State:Remove(object)
  local index = self.Ids[object]
  if index then 
  	table.remove(self.Objects, index) 
  	self.Ids[object] = nil
  end
end
return State