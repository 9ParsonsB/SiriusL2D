Vector = {}

function Vector.Len(x, y)
  return math.sqrt(x * x + y * y)
end

function Vector.LenSq()
  return x * x + y * y
end

function Vector.Normalize(x, y)
  local len = Vector.Len(x, y)
  x = x / len
  y = y / len
  return x, y
end