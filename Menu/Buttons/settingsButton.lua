Class("SettingsButton", "Button")

SettingsButton.Width = 150
SettingsButton.Height = 50
SettingsButton.State = "MainMenu"
SettingsButton.Text = "Settings"

function SettingsButton:PressedButton()
  Engine.SetState("SettingsMenu")
end

function SettingsButton:EnteredButton()
  self.Texture = "blueRect.png"
end

function SettingsButton:LeftButton()
  self.Texture = "greenRect.png"
end