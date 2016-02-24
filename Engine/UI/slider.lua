local Slider = Class("Slider")

Slider.Direction = 0
Slider.Min = 0
Slider.Max = 0
Slider.Value = 0
Slider.rValue = 0.0
Slider.Selected = false

function Slider:Create(x, y, width, height)
  self.X, self.Y = x or 0, y or 0
  self.Width, self.Height = width or 0, height or 0

  self.BarX, self.BarY = self.X, self.Y
  self.BarWidth, self.BarHeight = self.Width / 12, self.Height

  --Default textures
  self.Texture = "greyRect.png"
  self.BarTexture = "greenRect.png"

  Engine.Add(self)
end

function Slider:SetRange(min, max)
  self.Min = min
  self.Max = max
end

function Slider:MousePressed(x, y, button, isTouch)
  if button == 1 and self:BarContains(x, y) then
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
  	  self.BarY = y - self.BarHeight / 2
  	  self.BarY = math.max(self.Y, self.BarY)
  	  self.BarY = math.min(self.Y + self.Height - self.BarHeight, self.BarY)
  	end
  end
end

function Slider:UpdateValue(dx, dy)
  --Get distance as percentage
  local percent = 0
  if self.Direction == 0 then percent = dx / self.Width end
  if self.Direction == 1 then percent = dy / self.Height end

  --Calculate new value
  self.rValue = self.rValue + (percent * self.Max)
  self.rValue = math.min(self.rValue, self.Max)
  self.rValue = math.max(self.rValue, self.Min)
  self.Value = math.ceil(self.rValue)
end

function Slider:Contains(x, y)
  return x > self.X and x < self.X + self.Width
  and y > self.Y and y < self.Y + self.Height
end

function Slider:BarContains(x, y)
  return x > self.BarX and x < self.BarX + self.BarWidth
  and y > self.BarY and y < self.BarY + self.BarHeight
end

function Slider:GUI()
  local angle = self.Direction * 90
  Renderer.DrawSprite(self.Texture, self.X, self.Y, angle, self.Width, self.Height, 0, 0)
  Renderer.DrawSprite(self.BarTexture, self.BarX, self.BarY, angle, self.BarWidth, self.BarHeight, 0, 0)
end

return Slider