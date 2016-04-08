require "Engine/Common/class"
require "Engine/Common/tablelib"

require "Engine/Network"
require "Engine/Physics"
require "Engine/Renderer"
require "Engine/Scene"
require "Engine/Ui"

local World = require "Engine/Scene/world"
local GameObject = require "Engine/Scene/gameobject"

local function load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  love.graphics.setBackgroundColor(104, 136, 248)
end

local function update(dt)
  World.Update(dt)
  Physics.Update(dt)
  Script.Reload()
  Camera:Update(dt)
end

local function draw()
  Camera:Set() 
  World.Draw()
  Physics.Draw()
  Camera:Unset()

  Ui.Draw()
end

local function keypressed(key) 
  World.KeyPressed(key)
  Camera:KeyPressed(key)
end

local function keyreleased(key) 
  World.KeyReleased(key)
  Camera:KeyReleased(key)
end

local function mousepressed(x, y, button, isTouch) 
  World.MousePressed(x, y, button, isTouch)
  Camera:MousePressed(x, y, button, isTouch)
end

local function mousereleased(x, y, button, isTouch) 
  World.MouseReleased(x, y, button, isTouch)
  Camera:MouseReleased(x, y, button, isTouch)
end

local function mousemoved(x, y, dx, dy) 
  World.MouseMoved(x, y, dx, dy)
  Camera:MouseMoved(x, y, dx, dy) 
end

local function wheelmoved(x, y) 
  World.WheelMoved(x, y)
  Camera:WheelMoved(x, y)
end

--Connect engine to love2d
love.load = load
love.update = update
love.draw = draw
love.keypressed = keypressed
love.keyreleased = keyreleased
love.mousepressed = mousepressed
love.mousereleased = mousereleased
love.mousemoved = mousemoved
love.wheelmoved = wheelmoved

--Object definition/creation
local ObjectTypes = {}

function Object(name, parent)
  local self = Class(name, parent or GameObject)
  ObjectTypes[name] = self
  Script.Env[name] = self
  return self
end

function Instance(name, x, y, angle)
  if not ObjectTypes[name] then error(name .. " not defined") end

  local self = {X = x, Y = y, Angle = angle, Id = Network.UUID()}
  setmetatable(self, {__index=ObjectTypes[name]})

  World.Add(self)
  self:Create() 

  --Create collider for object
  local collider = Physics.Colliders[self]
  if not collider and self.UsePhysics then Physics.Add(self) end

  --Create animation for object
  if self.Animation then Renderer.Animation(self, self.Animation, self.State, self.Loop) end

  return self
end