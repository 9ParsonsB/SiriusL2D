local Button = Class("Button")

function Button:init(x, y, width, height, text)
  self.X, self.Y = x or 0, y or 0
  self.Width, self.Height = width or 0, height or 0
  self.Text = text or "A button"

  self.Pressed = false
  self.MouseOver = false
  Engine.Add(self)
end

function Button:MouseMoved(x, y, dx, dy)
  --Mouse entered button
  if self:Contains(x, y) and not self.MouseOver then
    self.OnMouseEnter()
    self.MouseOver = true

    --Texture change
    local texture = self.Texture
    self.Texture = self.Hover or self.Texture
    self.Hover = texture
  end

  --Mouse left button
  if not self:Contains(x, y) and self.MouseOver then
    self.OnMouseExit()
    self.MouseOver = false

    --Texture change
    local texture = self.Texture
    self.Texture = self.Hover or self.Texture
    self.Hover = texture
  end
end

function Button:GUI()
  if self.Texture then
    Renderer.DrawSprite(self.Texture, self.X, self.Y, 0, self.Width, self.Height, 0, 0)
  end
  love.graphics.print(self.Text, self.X, self.Y)
end

function Button:MousePressed(x, y, button, istouch)
  self.Pressed = self.MouseOver and button == 1
  self.OnClick()
end

function Button:MouseReleased(x, y, button)
  self.Pressed = false
end

function Button:Contains(x, y)
  return x > self.X and x < self.X + self.Width
  and y > self.Y and y < self.Y + self.Height
end

--Callbacks
function Button:OnClick() end
function Button:OnMouseEnter() end
function Button:OnMouseExit() end

return Button