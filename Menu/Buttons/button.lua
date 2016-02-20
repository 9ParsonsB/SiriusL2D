Class("Button")

Button.X = 0
Button.Y = 0
Button.Width = 100
Button.Height = 100
Button.Text = "A button"
Button.Texture = "greenRect.png"

Button.Down = false
Button.Over = false
Button.OldOver = false

function Button:Create(x, y)
  self.X, self.Y = x or 0, y or 0
  if self.State then
    Engine.Add(self, self.State)
  end
end

function Button:Update(dt)
  self.Over = false
  if self:Contains(love.mouse:getPosition()) then self.Over = true end

  --Callbacks
  if self.Over and not self.OldOver then self:EnteredButton() end
  if not self.Over and self.OldOver then self:LeftButton() end

  self.OldOver = self.Over
end

function Button:Draw()
  Renderer.DrawSprite(self.Texture, self.X, self.Y, 0, self.Width, self.Height, 0, 0)
  love.graphics.print(self.Text, self.X, self.Y)
end

function Button:Contains(x, y)
  return x > self.X 
  and x < self.X + self.Width 
  and y > self.Y 
  and y < self.Y + self.Height
end

function Button:MousePressed(x, y, button, istouch)
  if not button == "l" then return end

  --Get mouse position
 -- local camera = Engine.GetCamera(self.State)
  --local x, y = camera:GetMousePosition()

  --Run pressed callback
  if self:Contains(love.mouse:getPosition()) then
  	self:PressedButton()
  	Button.Down = true
  end
end

function Button:MouseReleased(x, y, button)
  if button == "l" then Button.Down = false end
end

--Callbacks
function Button:PressedButton() end
function Button:EnteredButton() end
function Button:LeftButton() end