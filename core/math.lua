local ffi = require "ffi"

ffi.cdef[[
  typedef struct Vector2 {
    float x, y;
  } Vector2;
]]

local Vector2 = {}
ge.Vector2 = ffi.metatype("Vector2", Vector2)
Vector2.__index = Vector2

function Vector2.__add(a, b)
	if type(a) == "number" then
		return ge.Vector2(b.x + a, b.y + a)
	elseif type(b) == "number" then
		return ge.Vector2(a.x + b, a.y + b)
	else
		return ge.Vector2(a.x + b.x, a.y + b.y)
	end
end

function Vector2.__sub(a, b)
	if type(a) == "number" then
		return ge.Vector2(b.x - a, b.y - a)
	elseif type(b) == "number" then
		return ge.Vector2(a.x - b, a.y - b)
	else
		return ge.Vector2(a.x - b.x, a.y - b.y)
	end
end

function Vector2.__mul(a, b)
	if type(a) == "number" then
		return ge.Vector2(b.x * a, b.y * a)
	elseif type(b) == "number" then
		return ge.Vector2(a.x * b, a.y * b)
	else
		return ge.Vector2(a.x * b.x, a.y * b.y)
	end
end

function Vector2.__div(a, b)
	if type(a) == "number" then
		return Vector2(b.x / a, b.y / a)
	elseif type(b) == "number" then
		return ge.Vector2(a.x / b, a.y / b)
	else
		return ge.Vector2(a.x / b.x, a.y / b.y)
	end
end

function Vector2.__eq(a, b)
  return a.x == b.x and a.y == b.y
end

function Vector2.__lt(a, b)
  return a.x < b.x or (a.x == b.x and a.y < b.y)
end

function Vector2.__le(a, b)
  return a.x <= b.x and a.y <= b.y
end

function Vector2.__tostring(a)
  return "(" .. a.x .. ", " .. a.y .. ")"
end

function Vector2.distance(a, b)
  return (b - a):len()
end

function Vector2:clone()
  return ge.Vector2(self.x, self.y)
end

function Vector2:unpack()
  return self.x, self.y
end

function Vector2:len()
  return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vector2:lenSq()
  return self.x * self.x + self.y * self.y
end

function Vector2:normalize(scale)
  if self.x == 0 and self.y == 0 then return end
  local len = self:len()
  self.x = (self.x / len) * (scale or 1)
  self.y = (self.y / len) * (scale or 1)
  return self
end

function Vector2:normalized()
  return self / self:len()
end

function Vector2:rotate(phi)
  local c = math.cos(phi)
  local s = math.sin(phi)
  self.x = c * self.x - s * self.y
  self.y = s * self.x + c * self.y
  return self
end

function Vector2:rotated(phi)
  return self:clone():rotate(phi)
end

function Vector2:perpendicular()
  return ge.Vector2(-self.y, self.x)
end

function Vector2:projectOn(other)
  return (self * other) * other / other:lenSq()
end

function Vector2:cross(other)
  return self.x * other.y - self.y * other.x
end

-- orthographic camera
local ffi = require "ffi"
ffi.cdef[[
  typedef struct Camera {
    Vector2 position;
    Vector2 size;
    Vector2 iSize;
    float r;
    float zoom;
  } Camera;
]]

local Camera = {}
local CCamera = ffi.metatype("Camera", Camera)
Camera.__index = Camera
Camera.current = nil

function ge.Camera(x, y, w, h)
  local position = ge.Vector2(x or 0, y or 0)
  local size = ge.Vector2(w or 1, h or 1)
  local iSize = ge.Vector2(love.graphics.getDimensions())
  local r = 0
  local zoom = 1
  return CCamera(position, size, iSize, r, zoom)
end

function Camera:update(dt)
  if ge.down(3) then self.position = self.position + ge.Vector2(-ge.delta.x, -ge.delta.y) end
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
  return Vector2(x, y)
end

function Camera:mouse()
  return self:project(love.mouse.getPosition())
end

function Camera:zoom()
  value = 1 - (value * 0.1)
  self.zoom = self.zoom * value
end

function Camera:bind()
  if self.current then
    love.graphics.pop()
    self.current = nil
    return
  end

  self.current = self
  -- dimensions, center
  local w, h = love.graphics.getDimensions()
  local size = self.position + ge.Vector2(w / 2, h / 2)
  
  -- scale to screen size
  love.graphics.push()
  love.graphics.scale(w / self.iSize.x, h / self.iSize.y)
  love.graphics.translate(w / 2, h / 2)
  love.graphics.scale(1 / self.zoom)
  love.graphics.rotate(-math.rad(self.r))
  love.graphics.translate(-self.position.x - w / 2, -self.position.y - h / 2)
end

-- util
function ge.vDirection(r) 
  return Vector2(math.cos(r), math.sin(r))
end

function ge.direction(node, point)
  return math.atan2(point.y - node.position.y, point.x - node.position.x)
end

function math.round(num)
  return math.floor(num+0.5)
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

function ge.mod(a, b) 
  return a - math.floor(a/b)*b 
end

function ge.containsCircle(mx, my, x, y, radius)
  local sqr = math.sqrt(math.pow(x - mx, 2) + math.pow(y - my, 2))
  return sqr <= radius
end

function ge.contains(a, b, x, y, w, h)
  return a > x and a < x + w and b > y and b < y + h
end

function ge.aabb(x1, y1, w1, h1, x2, y2, w2, h2)
  return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

function ge.to2D(index, rows)
  return math.fmod(index, rows), math.floor(index / rows)
end

function ge.moveTo(node, point, speed)
  local distance = point - node.position
  local length = distance:len()
  if length == 0 then return end
  local movement = distance:normalize() * math.min(length, speed)
  node.position = node.position + movement
end

-- line up velocity
--[[function ge.alignment(node, list)
  local point = Vec(0, 0)
  local neighborCount = 0

  for k,v in pairs(list) do
    if v ~= node then
      if node.position:distance(v.position) < 300 then
        point = point + node.velocity
        neighborCount = neighborCount + 1
      end
    end

    if neighborCount == 0 then 
      return point
    end

    point = point / neighborCount
    point:normalize()
    return point
  end
end

-- steer towards center
function ge.cohesion(node, list)
  local point = Vec(0, 0)
  local neighborCount = 0

  for k,v in pairs(list) do
    if v ~= node then
      if node.position:distance(v.position) < 300 then
        point = point + node.position
        neighborCount = neighborCount + 1
      end
    end

    if neighborCount == 0 then 
      return point
    end

    point = point / neighborCount
    point = point - node.position
    point:normalize()
    return point
  end
end

-- steer away from neighbors
function ge.separation(node, list)
  local point = Vec(0, 0)
  local neighborCount = 0

  for k,v in pairs(list) do
    if v ~= node then
      if node.position:distance(v.position) < 300 then
        point = point + (v.position - node.position)
        neighborCount = neighborCount + 1
      end
    end

    if neighborCount == 0 then 
      return point
    end

    point = point / neighborCount
    point = point * -1
    point:normalize()
    return point
  end
end--]]

