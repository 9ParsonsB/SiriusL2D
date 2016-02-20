Class("MainMenu")

function MainMenu:Create()
  self.Style = GUI.Style("greyRect.png", "greenRect.png")
  self.InGame = false
  Engine.Add(self, "MainMenu")
end

function MainMenu:GUI()
  --Starts game
  if GUI.Button(200, 450, 100, 20, "Start game") then
    self:StartGame()
  end

  --Settings
  if GUI.Button(200, 470, 100, 20, "Settings") then
    Engine.SetState("SettingsMenu")
  end

  --Quit
  if GUI.Button(200, 490, 100, 20, "Quit to desktop") then
    love.event.quit()
  end
end

function MainMenu:StartGame()
  Engine.SetState("Game")
  if self.InGame then return end
  self.InGame = true

  NewObject("Ship")
  NewObject("Player")
  NewObject("Debug")
end