local Physics = {}

Physics.Active = true
Physics.Debug = false
Physics.World = love.physics.newWorld(0, 0, true)

function Physics.Update(dt)
	if Physics.Active then Physics.World:update(dt) end
end

function Physics.Draw(dt)
  if not Physics.Debug then return end

  --Draw all shapes
  for k,v in pairs(Physics.World:getBodyList()) do
    Physics.DrawBody(v)
  end
end

function Physics.DrawBody(body)
  for k,v in pairs(body:getFixtureList()) do
    local shape = v:getShape()
    love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))
  end
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

--Register world callbacks
Physics.World:setCallbacks(Physics.beginContact, Physics.endContact)

return Physics