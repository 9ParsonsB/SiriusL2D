local Entity = require "Engine/entity"
local Text = require "Engine/text"

local DebugInfo = Class.New("DebugInfo", Entity)
function DebugInfo:Create(x, y)
	self.X = x
	self.Y = y
    self:SetScreen("Debug")
end
function DebugInfo:Draw()
    --Frame rate
    love.graphics.print("Frame rate: " .. love.timer.getFPS(), self.X, self.Y)

    --Render info
    local name, version, vendor, device = love.graphics.getRendererInfo()
    love.graphics.print(name .. " " .. version, self.X, self.Y + 15)
    love.graphics.print(vendor .. " " .. device, self.X, self.Y + 30)

    --Memory usage
    love.graphics.print('Memory used(KB): ' .. collectgarbage('count'), self.X, self.Y + 45)

    --Bullet count
    love.graphics.print("Bullet count: " .. (Class.GetNumObjects("Bullet") or 0), self.X, self.Y + 60)
end
return DebugInfo