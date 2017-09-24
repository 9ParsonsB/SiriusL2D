local class = require "core/class"

local Vec = class("Vec")
function Vec:init(x, y)
  self.x = x or 0
  self.y = y or 0
end

function Vec.__add(a, b)
  if type(a) == "number" then
    return Vec(b.x + a, b.y + a)
  elseif type(b) == "number" then
    return Vec(a.x + b, a.y + b)
  else
    return Vec(a.x + b.x, a.y + b.y)
  end
end

function Vec.__sub(a, b)
  if type(a) == "number" then
    return Vec(b.x - a, b.y - a)
  elseif type(b) == "number" then
    return Vec(a.x - b, a.y - b)
  else
    return Vec(a.x - b.x, a.y - b.y)
  end
end

function Vec.__mul(a, b)
  if type(a) == "number" then
    return Vec(b.x * a, b.y * a)
  elseif type(b) == "number" then
    return Vec(a.x * b, a.y * b)
  else
    return Vec(a.x * b.x, a.y * b.y)
  end
end

function Vec.__div(a, b)
  if type(a) == "number" then
    return Vec(b.x / a, b.y / a)
  elseif type(b) == "number" then
    return Vec(a.x / b, a.y / b)
  else
    return Vec(a.x / b.x, a.y / b.y)
  end
end

function Vec.__eq(a, b)
  return a.x == b.x and a.y == b.y
end

function Vec.__lt(a, b)
  return a.x < b.x or (a.x == b.x and a.y < b.y)
end

function Vec.__le(a, b)
  return a.x <= b.x and a.y <= b.y
end

function Vec.__tostring(a)
  return "(" .. a.x .. ", " .. a.y .. ")"
end

function Vec.distance(a, b)
  return (b - a):len()
end

function Vec:clone()
  return Vec(self.x, self.y)
end

function Vec:unpack()
  return self.x, self.y
end

function Vec:len()
  return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vec:lenSq()
  return self.x * self.x + self.y * self.y
end

function Vec:normalize(scale)
  if self.x == 0 and self.y == 0 then return end
  local len = self:len()
  self.x = (self.x / len) * (scale or 1)
  self.y = (self.y / len) * (scale or 1)
  return self
end

function Vec:normalized()
  return self / self:len()
end

function Vec:rotate(phi)
  local c = math.cos(phi)
  local s = math.sin(phi)
  self.x = c * self.x - s * self.y
  self.y = s * self.x + c * self.y
  return self
end

function Vec:rotated(phi)
  return self:clone():rotate(phi)
end

function Vec:perpendicular()
  return Vec(-self.y, self.x)
end

function Vec:projectOn(other)
  return (self * other) * other / other:lenSq()
end

function Vec:cross(other)
  return self.x * other.y - self.y * other.x
end

-- orthographics camera
local Camera = class("Camera")
function Camera:init(x, y, w, h)
  self.position = Vec(x, y)
  self.size = Vec(w, h)
  self.r = 0
  self.zoom = 1
  self.iSize = Vec(love.graphics.getDimensions())
end

function Camera:update(dt)
  if ge.down(3) then self.position = self.position + Vec(-ge.delta.x, -ge.delta.y) end
  -- self:zoom(ge.wheel.y)
end

function Camera:project(x, y)
  local w2, h2 = love.graphics.getWidth() / 2, love.graphics.getHeight() / 2
  local scale = 1 / self.zoom
  local sin, cos = math.sin(self.r), math.cos(self.r)
  x,y = x - w2, y - h2 -- add offset
  x,y = x / scale, y / scale -- scale
  x, y = cos * x - sin * y, sin * x + cos * y -- rotation
  x,y = x + w2, y + h2  -- sub offset
  x,y = x + self.position.x, y + self.position.y -- translate
  return Vec(x, y)
end

function Camera:mouse()
  return self:project(love.mouse.getPosition())
end

function Camera:zoom()
  value = 1 - (value * 0.1)
  self.zoom = self.zoom * value
end

-- maths
function ge.vectorDirection(r) 
  return Vec(math.cos(r), math.sin(r))
end

function ge.direction(node, point)
  local distance = point - node.position
  return math.atan2(point.y - node.position.y, point.x - node.position.x)
end

function ge.face(a, b) 
  return math.atan2(b.y - a.y, b.x - a.x) 
end

function ge.clamp(val, min, max) 
  return math.max(min, math.min(val, max)) 
end

function ge.lerp(a,b,t) 
  return (1-t)*a + t*b 
end

function ge.lerp2(a,b,t) 
  return a+(b-a)*t 
end

function ge.sign(v)
  if v < 0 then return -1 else return 1 end 
end

function ge.intersectCircle(mx, my, x, y, radius)
  local sqr = math.sqrt(math.pow(x - mx, 2) + math.pow(y - my, 2))
  return sqr <= radius
end

function ge.intersectBox(a, b, x, y, w, h)
  return a > x and a < x + w and b > y and b < y + h
end

function ge.aabb(x1, y1, w1, h1, x2, y2, w2, h2)
  return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
end

function ge.to2D(index, rows)
  return math.fmod(index, rows), math.floor(index / rows)
end

function ge.moveTowardPoint(node, point, speed)
  local distance = point - node.position
  local length = distance:len()
  if length == 0 then return end
  local movement = distance:normalize() * math.min(length, speed)
  node.position = node.position + movement
end
return {Vec, Camera}