GUI = {}
GUI.LeftPressed = false

function GUI.Style(texture, selectTexture)
  local style = {}
  style.Texture = texture
  style.SelectTexture = selectTexture
  return style
end

--Draws button and returns if button is pressed
function GUI.Button(x, y, width, height, text, style)
  --If mouse over area
  if GUI.MouseOver(x, y, width, height) then

    --Draw button with hover texture
    if style then
      Renderer.DrawSprite(style.SelectTexture, x, y, 0, width, height, 0, 0)
    end
  
    love.graphics.print(text, x, y)
    return GUI.LeftPressed
  end

  --Draw button with default texture
  if style then
    Renderer.DrawSprite(style.Texture, x, y, 0, width, height, 0, 0)
  end
  love.graphics.print(text, x, y)

  return false
end

--Checks if mouse over area
function GUI.MouseOver(x, y, width, height)
  local mouseX, mouseY = love.mouse.getPosition()
  return mouseX > x and mouseX < x + width
  and mouseY > y and mouseY < y + height
end

--[[Button = {}
function Button:New(x, y, width, height, text, texture)
  local self = setmetatable({}, {__index = Button})

  self.X, self.Y = x or 0, y or 0
  self.Width, self.Height = width or 0, height or 0
  self.Text = text or ""
  self.Texture = texture or "A button"
  self.Selected = false

  return self
end

function Button:Select(texture)
  if texture then
    self.Texture = texture
  end
  self.Selected = true
end

function Button:Deselect(texture)
  if texture then
    self.Texture = texture
  end
  self.Selected = false
end

--Checks if mouse over area
function Button:MouseOver()
  local x, y = love.mouse.getPosition()
  return x > self.X and x < self.X + self.Width
  and y > self.Y and y < self.Y + self.Height
end

function Button:Draw()
  Renderer.DrawSprite(self.Texture, self.X, self.Y, 0, self.Width, self.Height, 0, 0)
  love.graphics.print(self.Text, self.X, self.Y)
end
setmetatable(Button, {__call=Button.New})--]]