Transform = {}

--[[function Transform.Len(x, y)
  return math.sqrt(x * x + y * y)
end

function Transform.LenSq()
  return x * x + y * y
end

function Transform.Normalize(x, y)
  local len = Vector.Len(x, y)
  x = x / len
  y = y / len
  return x, y
end--]]