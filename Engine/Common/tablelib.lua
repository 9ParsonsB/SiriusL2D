function table.contains(t, value)
  for k,v in pairs(t) do
    if v == value then self.Elements[k] = nil end
  end
end

function table.clear(t)
  for k,v in pairs(t) do
    t[k] = nil
  end
end

function table.removevalue(t, value)
  for k,v in pairs(t) do
    if v == value then t[k] = nil end
  end
end