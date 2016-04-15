require "Engine/Common/class"
require "Engine/Common/tablelib"

require "Engine/Input"
require "Engine/Network"
require "Engine/Physics"
require "Engine/Renderer"
require "Engine/Scene"
require "Engine/Ui"

local GameObject = require "Engine/Scene/gameobject"

--Physics issue to do with the physics meter???
--Seems to be the max distance per frame???
love.physics.setMeter(140)

local function load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  love.graphics.setBackgroundColor(104, 136, 248)
end

local function update(dt)
  Scene.Update(dt)
  Physics.Update(dt)
  Script.Reload()
  Camera:Update(dt)
end

local function draw()
  Camera:Set() 
  Scene.Draw()
  Physics.Draw()
  Camera:Unset()

  Ui.Draw()
end

local function keypressed(key) 
  Scene.KeyPressed(key)
  Camera:KeyPressed(key)
end

local function keyreleased(key) 
  Scene.KeyReleased(key)
  Camera:KeyReleased(key)
end

local function mousepressed(x, y, button, isTouch) 
  Scene.MousePressed(x, y, button, isTouch)
  Camera:MousePressed(x, y, button, isTouch)
end

local function mousereleased(x, y, button, isTouch) 
  Scene.MouseReleased(x, y, button, isTouch)
  Camera:MouseReleased(x, y, button, isTouch)
end

local function mousemoved(x, y, dx, dy) 
  Scene.MouseMoved(x, y, dx, dy)
  Camera:MouseMoved(x, y, dx, dy) 
end

local function wheelmoved(x, y) 
  Scene.WheelMoved(x, y)
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

  local self = {Position = Vector(x, y), Angle = angle, Id = Network.UUID()}
  setmetatable(self, {__index=ObjectTypes[name]})

  --Create collider for object
  local collider = Physics.Colliders[self]
  if not collider and self.UsePhysics then Physics.Add(self) end

  --Create animation for object
  if self.Animation then Renderer.Animation(self, self.Animation, self.State, self.Loop) end

  self:Create() 
  Scene.Add(self)

  return self
end

function Destroy(self)
  self:Destroy()
  Scene.Remove(self)

  local collider = Physics.Colliders[self]
  if collider then collider:Destroy() end
end