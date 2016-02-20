Class("ExitButton", "Button")

ExitButton.Width = 150
ExitButton.Height = 50
ExitButton.State = "MainMenu"
ExitButton.Text = "Exit game"

function ExitButton:PressedButton()
  love.event.quit()
end

function ExitButton:EnteredButton()
  self.Texture = "blueRect.png"
end

function ExitButton:LeftButton()
  self.Texture = "greenRect.png"
end