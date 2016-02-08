function Create(self, x, y)
	self.X = x
    self.Y = y
end
function Draw(self)
    --Frame rate
    love.graphics.print("Frame rate: " .. love.timer.getFPS(), self.X, self.Y)

    --Render info
    local name, version, vendor, device = love.graphics.getRendererInfo()
    love.graphics.print(name .. " " .. version, self.X, self.Y + 15)
    love.graphics.print(vendor .. " " .. device, self.X, self.Y + 30)

    --Memory usage
    love.graphics.print('Memory used(KB): ' .. collectgarbage('count'), self.X, self.Y + 45)
end