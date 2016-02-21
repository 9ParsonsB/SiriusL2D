Class("SettingsMenu")

function SettingsMenu:Create()
  Engine.Add(self, "SettingsMenu")
end

function SettingsMenu:KeyPressed(key)
  if key == "escape" then Engine.SetState("MainMenu") end
end