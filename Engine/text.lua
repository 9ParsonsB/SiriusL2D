local Text = Class.New("Text")
function Text:Create(value)
	self.Value = value
end
function Text:Draw(x, y, angle)
	love.graphics.print(self.Value, x or 0, y or 0, (math.pi / 180) * (angle or 0))
end
return Text