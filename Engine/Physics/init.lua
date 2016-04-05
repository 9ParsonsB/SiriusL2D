Physics = {
  Active = true, 
  Debug = true, 
  World = love.physics.newWorld(0, 0, true),
  Collider = require "Engine/Physics/collider",
  Colliders = {}
}

function Physics.Add(self)
  Physics.Collider(self, self.Physics)
end

function Physics.SetGravity(x, y)
  Physics.World:setGravity(x, y)
end

function Physics.Update(dt)
	if not Physics.Active then return end
  for k,v in pairs(Physics.Colliders) do v:BeginSync(dt) end
  Physics.World:update(dt) 
  for k,v in pairs(Physics.Colliders) do v:EndSync(dt) end
end

function Physics.Draw()
  if not Physics.Debug then return end
  for k,v in pairs(Physics.Colliders) do v:Draw() end
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
    self.Object:CollisionEnter(other.Object, coll)
    other.Object:CollisionEnter(self.Object, coll)
  end
end

function Physics.endContact(a, b, coll)
  local self = a:getUserData()
  local other = b:getUserData()
  if self and other then
    self.Object:CollisionExit(other.Object, coll)
    other.Object:CollisionExit(self.Object, coll)
  end
end

function Physics.postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
  local self = a:getUserData()
  local other = b:getUserData()

  self.Object.X, self.Object.Y = self:GetPosition()
  self.Angle = self:GetAngle()

  other.Object.X, other.Object.Y = other:GetPosition()
  other.Object.Angle = other:GetAngle()
end

--Register world callbacks
Physics.World:setCallbacks(Physics.beginContact, Physics.endContact, nil, Physics.postSolve)