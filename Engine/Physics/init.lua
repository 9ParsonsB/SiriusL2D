Physics = {
  Active = true, 
  Debug = true, 
  World = love.physics.newWorld(0, 0, true),
  Collider = require "Engine/Physics/collider",
  Colliders = {}
}

function Physics.SetGravity(x, y)
  Physics.World:setGravity(x, y)
end

function Physics.Update(dt)
	if Physics.Active then Physics.World:update(dt) end
end

local Objects = {}

local function Callback(fixture)
  local object = fixture:getUserData()
  if object then table.insert(Objects, object) end
  return 1
end

function Physics.RayCast(x1, y1, x2, y2)
  Objects = {}
  Physics.World:rayCast(x1, y1, x2, y2, Callback)
  return Objects
end

function Physics.GetObjects(topLeftX, topLeftY, bottomRightX, bottomRightY)
  Objects = {}
  Physics.World:queryBoundingBox(topLeftX, topLeftY, bottomRightX, bottomRightY, Callback)
end

function Physics.beginContact(a, b, coll)
  local self = a:getUserData()
  local other = b:getUserData()
  if self and other then
    if type(self.CollisionEnter) == "function" then self:CollisionEnter(other, coll) end
    if type(other.CollisionEnter) == "function" then other:CollisionEnter(self, coll) end
  end
end

function Physics.endContact(a, b, coll)
  local self = a:getUserData()
  local other = b:getUserData()
  if self and other then
    if type(self.CollisionExit) == "function" then self:CollisionExit(other, coll) end
    if type(other.CollisionExit) == "function" then other:CollisionExit(self, coll) end
  end
end

function Physics.postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
  local self = a:getUserData()
  local other = b:getUserData()

  self.X, self.Y = self.Collider:GetPosition()
  self.Angle = self.Collider:GetAngle()

  other.X, other.Y = other.Collider:GetPosition()
  other.Angle = other.Collider:GetAngle()
end

--Register world callbacks
Physics.World:setCallbacks(Physics.beginContact, Physics.endContact, nil, Physics.postSolve)