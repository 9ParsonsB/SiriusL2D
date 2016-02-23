local TextBox = Class("TextBox")

function TextBox:Create(x, y) 
  self.X, self.Y = x or 0, y or 0
  self.Text = ""
  Engine.Add(self)
end

function TextBox:TextInput(t)
  self.Text = self.Text .. t
  self:TextEntered(t)
end

function TextBox:KeyPressed(key)
  if key == "backspace" then
    print("BACKSPACE")
  end
end

function TextBox:GUI()
  love.graphics.print(self.Text, self.X, self.Y)
end

--Callbacks
function TextBox:TextEntered() end

return TextBox