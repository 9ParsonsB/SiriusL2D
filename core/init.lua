ge = {}

require "core/api"
require "core/gui"

function class(name, table)
  table.name = name
  table.__index = table
  return table
end

function ge.Node(info, x, y, z, r)
  local obj = setmetatable({}, info or {})
  obj.position = Vec(x, y)
  obj.velocity = Vec(0, 0)
  obj.r = r or 0
  obj.selected = false
  if type(obj.init) == "function" then obj:init() end
  return obj
end

local list = {}
list.__index = list
function list:add(info, x, y, z, r)
  table.insert(self, ge.Node(info, x, y, z, r))
  return self[#self]
end

function list:select(rect, texture)
  local position = rect.position or rect
  local size = rect.size or Vec(0, 0)
  ge.select(self, texture, position.x, position.y, position.x + size.x, position.y + size.y)
end

function ge.List(size, info, x, y, z)
  local list = setmetatable({}, list)
  for i=1, (size or 0) do list:add(info, x, y, z) end
  return list
end

function ge.drawGrid(x, y, w, h, rows, cols)
  for i=0, rows do ge.line(x + (i * w), y, x + (i * w), y + (cols * h)) end
  for i=0, cols do ge.line(x, y + (i * h), x + (rows * w), y + (i * h)) end
end

function ge.collision(node, texture, x1, y1, x2, y2)
  local a, b = math.min(x1, x2), math.min(y1, y2)
  local c, d = math.max(x1, x2), math.max(y1, y2)
  local w, h = texture:getDimensions()
  return ge.aabb(node.position.x - (w / 2), node.position.y - (h / 2), w, h, a, b, (c - a), (d-b)) 
end

function ge.select(t, texture, x1, y1, x2, y2)
  for k,v in pairs(t) do
    if ge.collision(v, texture, x1, y1, x2, y2) then
      v.selected = true
    else
      if not ge.down("lshift") then
        v.selected = false
      end
    end
  end
end

function ge.flocking(list)
  for k,v in pairs(list) do
    local alignment = ge.alignment(v, list)
    local cohesion = ge.cohesion(v, list)
    local separation = ge.separation(v, list)
    -- print(alignment) --, cohesion, separation)
    v.velocity = v.velocity + alignment -- + cohesion + separation
    v.velocity:normalize(30)
  end
end

-- line up velocity
function ge.alignment(node, list)
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
end
