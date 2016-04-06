local List = Class("List")

function List:Create()
  self.Elements = {}
end

function List:Add(value)
  table.insert(self.Elements, value)
end

function List:Remove(value)
  
end

function List:Contains(value)
  for k,v in pairs(self.Elements) do
  	if v == value then return true end
  end
  return false
end

function List:Size()

end
return List