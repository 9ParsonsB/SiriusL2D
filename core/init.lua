ge = {}

local ffi = require "ffi"
class = require "core.class"
require "core/api"
require "core/math"
require "core/gui"
-- require "core/nuklearTest"

ffi.cdef[[
  typedef struct Node {
    int * t;
    Vector2 position;
    Vector2 velocity;
    float r;
    bool selected;
  } Node;
]]

ge.nodes = setmetatable({}, {__mode="k"})

local Node = class("Node")
ge.Node = Node
function Node:init(x, y, r)
  self.position = ge.Vector2(x, y)
  self.velocity = ge.Vector2(0, 0)
  self.r = r or 0
  self.selected = false
  table.insert(ge.nodes, self)
end

function Node:snap(w, h)
  self.position.x = math.floor(self.position.x / w) * w
  self.position.y = math.floor(self.position.y / h) * h
end

function Node:collide(texture, x1, y1, x2, y2)
  x2, y2 = x2 or x1, y2 or y1
  local a, b = math.min(x1, x2), math.min(y1, y2)
  local c, d = math.max(x1, x2), math.max(y1, y2)
  local w, h = texture:getDimensions()
  return ge.aabb(self.position.x - (w / 2), self.position.y - (h / 2), w, h, a, b, (c - a), (d-b)) 
end

function Node:compare(position)
  return self:collide(self.sprite, position.x, position.y)
end

local List = class("List")
ge.List = List
function List:init(info, size, x, y, z)
  for i = 1, size or 0 do self:add(x, y, z) end
end

function List:clear()
  for i,v in ipairs(self) do v = nil end
end

function List:add(object)
  table.insert(self, object)
  return self[#self]
end

function List:remove(node)
  for k,v in pairs(self) do
    if v == node then table.remove(self, k) end
  end
end

function List:getNode(position)
  for k,v in pairs(self) do
    if v:compare(position) then
      return v
    end
  end
end

function List:select(obj, compare)
  local mouse = ge.mouse()
  for k,v in pairs(self) do
    if v:compare(mouse) then compare(obj, v, mouse) end
  end
end

function List:draw()
  for k,v in pairs(self) do
    if v.sprite then
      ge.push(v)
      ge.drawf(v.sprite, "center")
    end
  end
  ge.push()
end

local Grid = class("Grid")
ge.Grid = Grid
function Grid:init(rows, cols)
  self.rows = rows
  self.cols = cols
end

function Grid:get(x, y)
  if x > 0 and x < self.rows and y > 0 and y < self.cols then
    return self[x][y]
  end
end

function Grid:set(x, y, value)
  if x > 0 and x < self.rows and y > 0 and y < self.cols then
    self[x][y] = value
  end
end

-- grid class with place in world
local MpGrid = class("MpGrid", Grid)
ge.MpGrid = MpGrid
function MpGrid:init(x, y, rows, cols)
  Grid.init(self, rows, cols)
  self.position = ge.Vector2(x, y)
  self.w = 60
  self.h = 40
end

function MpGrid:add(node)
  local distance = node.position - self.position
  distance.x =  math.floor(distance.x / self.w)
  distance.y = math.floor(distance.y / self.h)
  
  -- try to add to grid
  if distance.x > -1 and distance.y > -1 and distance.x < self.rows and distance.y < self.cols then
    node.position = self.position + distance * ge.Vector2(self.w, self.h)
    node.position = node.position + ge.Vector2(self.w / 2, self.h / 2)

    return true
  end
  return false
end

function MpGrid:draw(w, h)
  local x, y = 0, 0
  ge.push(self)
  for i=0, self.rows do ge.line(x + (i * w), y, x + (i * w), y + (self.cols * h)) end
  for i=0, self.cols do ge.line(x, y + (i * h), x + (self.rows * w), y + (i * h)) end
  ge.push()
end

function ge.debug()
  local name, version, vendor, device = love.graphics.getRendererInfo()
  gui.begin("debug", 5, 5, 300, 10)
  gui.label("fps " .. love.timer.getFPS())
  gui.label(name .. " " .. version)
  gui.label(vendor .. " " .. device)
  gui.label("memory " .. collectgarbage("count"))
  gui.label("time " .. os.date("%H:%M:%S"))
  gui.label(love.system.getOS())
end

-- nebula shader(clouds)
-- use perlin noise to mix with texture
--[[local perlin = ge.read("res/classicnoise2D.glsl")
local source = ge.read("res/nebula.glsl")
cloud = ge.Shader(perlin .. source)
cloud:send("scale", (math.random() * 2 + 1) / scene.width)
cloud:send("uColor", {0.7, 0, 1})
cloud:send("density", math.random() * 0.05)
cloud:send("falloff", math.random() * 2.0 + 3.0)
cloud:send("offset", {math.random() * 100, math.random() * 100})

-- nebula texture(stars)
-- static so generated here
local map = ge.ImageData(1024, 768)
local density, brightness = 0.02, 0.125
local count = map:getWidth() * map:getHeight() * density
for i=0,count do
  local x = math.floor(math.random() * map:getWidth())
  local y = math.floor(math.random() * map:getHeight())
  local c = 255 * math.log(1 - math.random()) * -brightness
  map:setPixel(x, y, c, c, c, 255)
end
stars = ge.Texture(map)--]]
