local Object = require "Engine/object"

function love.load()
    love.graphics.setBackgroundColor(104, 136, 248)
    love.physics.setMeter(64)
    World = love.physics.newWorld(0, 5*64, true)
    World:setCallbacks(beginContact, endContact)

    Object.Load("debug", "Game/debug")
    Object.Load("player", "Game/player")
    Object.Load("wall", "Game/wall")

    Object.Create("debug", 0, 0)
    Object.Create("player", 100, 100)

    --Random amount of boxes
    math.randomseed(os.time())
    local count = math.random(100)
    for i = 0, count do
        Object.Create("wall", math.random(100, 1000), math.random(100, 700))
    end
end

function love.update(dt)
    for k,v in pairs(Object.Instances) do
        if v.Update then v:Update(dt) end
        v.X = v.X + v.VelX * dt
        v.Y = v.Y + v.VelY * dt
        v.Angle = v.Angle + v.AngularVel * dt
    end
    World:update(dt)
end

function love.draw()
    for k,v in pairs(Object.Instances) do
        if v.Draw then v:Draw() end
    end
end

--Physics callbacks
function beginContact(a, b, coll)
    local self = a:getUserData()
    local other = b:getUserData()

    if self and other then
        if type(self.CollisionEnter) == "function" then self:CollisionEnter(other, coll) end
        if type(other.CollisionEnter) == "function" then other:CollisionEnter(self, coll) end
    end
end

function endContact(a, b, coll)
    local self = a:getUserData()
    local other = b:getUserData()

    local bodyA = a:getBody()
    local bodyB = b:getBody()

    if self and other then
        --self.X = bodyA:getX()
        --self.Y = bodyA:getY()
        --self.Angle = (180 / math.pi) * bodyA:getAngle()
        self:SetLinearVelocity(bodyA:getLinearVelocity())
        --self:SetAngularVelocity(bodyA:getAngularVelocity())
        
        if type(self.CollisionExit) == "function" then self:CollisionExit(other, coll) end
        if type(other.CollisionExit) == "function" then other:CollisionExit(self, coll) end
    end
end