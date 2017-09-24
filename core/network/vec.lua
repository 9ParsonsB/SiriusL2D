vec = class("vec")

function vec:init(x, y)
  self.x = x or 0
  self.y = y or 0
end

function vec:clone()
  return vec(self.x, self.y)
end

function vec:__tostring( ... )
  return "vec(" .. self.x .. ", " .. self.y .. ")"
end

function vec.__unm(a)
  return vec(-a.x, -a.y)
end

function vec.__add(a, b)
  return vec(a.x + b.x, a.y + b.y);
end

function vec.__sub(a, b)
  return vec(a.x - b.x, a.y - b.y)
end

function vec.__mul(a, b)
  if type(a) == "number" then return vec(b.x * a, b.y * a) end
  if type(b) == "number" then return vec(a.x * b, a.y * b) end
  return vec(a.x * b.x, a.y * b.y)
end

function vec.__div(a, b)
  if type(a) == "number" then return vec(b.x / a, b.y / a) end
  if type(b) == "number" then return vec(a.x / b, a.y / b) end
  return vec(a.x / b.x, a.y / b.y)
end

function vec.__eq(a, b)
  return a.x == b.x and a.y == b.y
end

function vec.__lt(a, b)
  return a.x < b.x or (a.x == b.x and a.y < b.y)
end

function vec.__le(a, b)
  return a.x <= b.x and a.y <= b.y
end

function vec:min(a)
  return vec(math.min(self.x, a.x), math.min(self.y, a.y))
end

function vec:max(a)
  return vec(math.max(self.x, a.x), math.max(self.y, a.y))
end

function vec:clamp(length)
  return self:normalized() * math.min(self:length(), length)
  -- return vec(math.max(min.x, math.min(self.x, max.x)), math.max(min.y, math.min(self.y, max.y))
end

function vec:length()
  return math.sqrt(self.x * self.x + self.y * self.y)
end

function vec:normalize()
  local len = self:length()
  if len ~= 0 and len ~= 1 then
    self.x = self.x / len
    self.y = self.y / len
  end
  return self
end

function vec:normalized()
  return self:clone():normalize()
end

function vec:truncate(v, max)
  local i = max / self:length(v)
  if i > 1.0 then i = 1.0 end 
  return self:clone() * i
end

function vec:rotate(v, angle)
  local s = math.sin(angle)
  local c = math.cos(angle)

  self.x = v.x + (self.x - v.x) * c - (self.y - v.y) * s
  self.y = v.y + (self.x - v.x) * s + (self.y - v.y) * c
end

function vec:angle()
  return math.atan2(self.y, self.x)
end
return vec