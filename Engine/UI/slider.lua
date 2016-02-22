local Slider = Class("Slider")

function Slider:init(x, y, width, height)
  self.X, self.Y = x or 0, y or 0
  self.Width, self.Height = width or 0, height or 0

  self.BarX, self.BarY = self.X, self.Y
  self.BarWidth, self.BarHeight = self.Width / 12, self.Height

  --Default textures
  self.Texture = "greyRect.png"
  self.BarTexture = "greenRect.png"

  --0 - Horizontal, 1 - Vertical
  self.Direction = 0
  
  --Slider values
  self.Min, self.Max = 0,  1
  self.Value = self.Min

  self.Selected = false
end

function Slider:SetRange(min, max)
  self.Min = min
  self.Max = max
end

function Slider:MousePressed(x, y, button, isTouch)
  if button == 1 and self:Contains(x, y) then
  	self.Selected = true
  end
end

function Slider:MouseReleased(x, y, button)
  if button == 1 then self.Selected = false end
end

function Slider:MouseMoved(x, y, dx, dy)
  if self.Selected then
  	--Horizontal
  	if self.Direction == 0 then 
  	  self.BarX = x - self.BarWidth / 2
  	  self.BarX = math.max(self.X, self.BarX)
  	  self.BarX = math.min(self.X + self.Width - self.BarWidth, self.BarX)
  	end
  
    --Vertical
  	if self.Direction == 1 then 
  	  self.BarY = y
  	  self.BarY = math.max(self.Y, self.BarY)
  	  self.BarY = math.min(self.Y + self.Height - self.BarHeight, self.BarY)
  	end
  end
end

function Slider:Contains(x, y)
  return x > self.BarX and x < self.BarX + self.BarWidth
  and y > self.BarY and y < self.BarY + self.BarHeight
end

function Slider:GUI()
  local angle = self.Direction * 90
  Renderer.DrawSprite(self.Texture, self.X, self.Y, angle, self.Width, self.Height, 0, 0)
  Renderer.DrawSprite(self.BarTexture, self.BarX, self.BarY, angle, self.BarWidth, self.BarHeight, 0, 0)
end

return Slider