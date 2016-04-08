Vector = Class("Vector")

Vector.X, Vector.Y = 0

function Vector:Create(X, Y)
  self.X, self.Y = X or 0, Y or 0 
end

function Vector.__add(a, b)
  if type(a) == "number" then return Vector(b.X + a, b.Y + a) end
  if type(b) == "number" then return Vector(a.X + b, a.Y + b) end
  return Vector(a.X + b.X, a.Y + b.Y)
end

function Vector.__sub(a, b)
  if type(a) == "number" then return Vector(b.X - a, b.Y - a) end
  if type(b) == "number" then return Vector(a.X - b, a.Y - b) end
  return Vector(a.X - b.X, a.Y - b.Y)
end

function Vector.__mul(a, b)
  if type(a) == "number" then return Vector(b.X * a, b.Y * a) end 
  if type(b) == "number" then return Vector(a.X * b, a.Y * b) end
  return Vector(a.X * b.X, a.Y * b.Y)
end

function Vector.__div(a, b)
  if type(a) == "number" then return Vector(b.X / a, b.Y / a) end
  if type(b) == "number" then return Vector(a.X / b, a.Y / b) end
  return Vector.new(a.X / b.X, a.Y / b.Y)
end

function Vector.__eq(a, b)
  return a.X == b.X and a.Y == b.Y
end

function Vector.__lt(a, b)
  return a.X < b.X or (a.X == b.X and a.Y < b.Y)
end

function Vector.__le(a, b)
  return a.X <= b.X and a.Y <= b.Y
end

function Vector.__tostring(a)
  return "(" .. a.X .. ", " .. a.Y .. ")"
end

function Vector.Distance(a, b)
  return (b - a):Len()
end

function Vector:Len()
  return math.sqrt(self.X * self.X + self.Y * self.Y)
end

function Vector:Normalize()
  local len = self:Len()
  self.X = self.X / len
  self.Y = self.Y / len
  return self
end
