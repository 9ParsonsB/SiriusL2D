local TextBox = Class("TextBox")

function TextBox:init(x, y) 
  self.X, self.Y = x or 0, y or 0
  self.Text = ""
end

function TextBox:TextInput(t)
  self.Text = self.Text .. t
end

function TextBox:KeyPressed(key)
  if key == "backspace" then
    print("BACKSPACE")
  end
end

function TextBox:GUI()
  love.graphics.print(self.Text, self.X, self.Y)
end
return TextBox