Class("SettingsMenu")

function SettingsMenu:Create()
  self.Slider = NewObject("Slider", 200, 200, 200, 20)
  self.Slider:SetRange(0, 100)

  Engine.Add(self.Slider, "SettingsMenu")
  Engine.Add(self, "SettingsMenu")
end

function SettingsMenu:KeyPressed(key)
  if key == "escape" then Engine.SetState("MainMenu") end
end