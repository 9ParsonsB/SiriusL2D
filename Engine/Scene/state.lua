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
  if not index then return end

  --Move last element to objects location
  local last = self.Objects[#self.Objects]
  self.Objects[index] = last
  self.Ids[last] = index

  --Remove last element
  table.remove(self.Objects) 
  self.Ids[object] = nil
end
return State