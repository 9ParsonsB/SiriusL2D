local Renderer = require "Engine/renderer"
local Events = require "Engine/events"

local Object = {}

Object.Types = {}
Object.Instances = {}
Object.Count = 0

function Object.Load(name, filePath)
    local env = {}

    --Default enviroment values
    env.Object = Object
    env.Renderer = Renderer
    env.love = love
    env.print = print
    env.World = World

    function env:GetLinearVelocity()
        if self.Body then return self.Body:getLinearVelocity(x, y) end
        return self.VelX, self.VelY
    end

    function env:SetLinearVelocity(x, y)
        if self.Body then self.Body:setLinearVelocity(x, y) end
        self.VelX = x
        self.VelY = y
    end

    function env:GetAngularVelocity()
        if self.Body then return self.Body:getAngularVelocity() end
        return self.AngularVel
    end

    function env:SetAngularVelocity(amount)
        if self.Body then self.Body:setAngularVelocity(amount) end
        self.AngularVel = amount
    end

    --Load file
    assert(loadfile(filePath .. ".lua", 't', env))()

    Object.Types[name] = env
end
function Object.Create(name, ...)
    local obj = setmetatable({}, {__index=Object.Types[name]})

    obj.X = 0
    obj.Y = 0
    obj.VelX = 0
    obj.VelY = 0
    obj.Angle = 0
    obj.AngularVel = 0

    --Call constructor
    if type(obj.Create) == "function" then obj:Create(...) end

    Object.Instances[Object.Count] = obj
    Object.Count = Object.Count + 1

    return obj
end
return Object