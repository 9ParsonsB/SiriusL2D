local Transform = require "Engine/Scene/transform"
local GameObject = Class("GameObject", Transform)

GameObject.Active = true

--Animation info
GameObject.State = "idle"
GameObject.Loop = true

--Physics info
GameObject.UsePhysics = false
GameObject.Type = "dynamic"
GameObject.Shape = "box"

--Object size
GameObject.Width = 16
GameObject.Height = 16

GameObject.Replicated = false

--Overridable functions
function GameObject:Create() end
function GameObject:Destroy() end
function GameObject:Update(dt) end
function GameObject:Ui() end
function GameObject:Sync(object) end
function GameObject:Draw() end

function GameObject:Selected() end
function GameObject:Deselected() end

function GameObject:CollisionEnter(object, coll) end
function GameObject:CollisionExit(object, coll) end

function GameObject:KeyPressed(key) end
function GameObject:KeyReleased(key) end

function GameObject:MousePressed(x, y, button, isTouch) end
function GameObject:MouseReleased(x, y, button, isTouch) end
function GameObject:MouseMoved(x, y, dx, dy) end
function GameObject:WheelMoved(x, y) end

--Type check
function GameObject:IsType(name)
  local object = self
  while object do
    if object.Name == name then return true end
    object = object.Parent
  end
  return false
end

function GameObject:PlayAnimation(state)
  Renderer.Animation(self, self.Animation, state, self.Loop)
end

function GameObject:PlaySound(filePath, type)
  local sound = love.audio.newSource(filePath, type)
  sound:play()
  return sound  
end

function GameObject:SetSize(width, height)
  self.Width = width
  self.Height = height
end

--If object contains point
function GameObject:Contains(a, b)
  local x, y = self.X - (self.Width / 2), self.Y - (self.Height / 2)
  return a >= x and a <= x + self.Width and b >= y and b <= y + self.Height
end

--If mouse over object
function GameObject:MouseOver()
  return self:Contains(Camera:GetMousePosition())
end

--If object in area
function GameObject:InArea(x, y, width, height)
  return math.abs(self.Position.X - x) * 2 <= (self.Width + width) and math.abs(self.Position.Y - y) * 2 <= (self.Height + height)
end
return GameObject