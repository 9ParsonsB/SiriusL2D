Vector = Class("Vector")

Vector.X, Vector.Y = 0

function Vector:Create(x, y)
  self.X, self.Y = x or 0, y or 0 
end

function Vector:Copy()
  return Vector(self.X, self.Y)
end

function Vector:Distance(v)
  return (self - v)
end

function Vector:Length()
  return math.sqrt(self.X ^ 2 + self.Y ^ 2)
end

function Vector:LengthSqr()
  return self.X ^ 2 + self.Y ^ 2
end

function Vector:Normalize()
  local len = self:Length()
  self.X = self.X / len
  self.Y = self.Y / len
  return self
end

function Vector:ToAngle()
  return math.atan2(self.Y, self.X)
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
  return "vector: (" .. a.X .. ", " .. a.Y .. ")"
end