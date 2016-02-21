Class("MainMenu")

function MainMenu:Create()
  --Create buttons
  self.Start = NewObject("Button", 200, 400, 100, 20, "Single player")
  self.Start:SetTexture("greyRect.png", "greenRect.png")

  self.StartServer = NewObject("Button", 200, 430, 100, 20, "Multiplayer")
  self.StartServer:SetTexture("greyRect.png", "greenRect.png")

  self.Settings = NewObject("Button", 200, 460, 100, 20, "Settings")
  self.Settings:SetTexture("greyRect.png", "greenRect.png")

  self.Quit = NewObject("Button", 200, 490, 100, 20, "Quit")
  self.Quit:SetTexture("greyRect.png", "greenRect.png")

  self.InGame = false
  Engine.Add(self, "MainMenu")
end

--Quit game when escape pressed
function MainMenu:KeyPressed(key)
  if key == "escape" then love.event.quit() end
end

--Handle button presses
function MainMenu:MousePressed(x, y, button, isTouch)
  if self.Start.Pressed then self:StartGame() end
  if self.Settings.Pressed then Engine.SetState("SettingsMenu") end
  if self.Quit.Pressed then love.event.quit() end
end

function MainMenu:StartGame()
  Engine.SetState("Game")
  if self.InGame then return end
  self.InGame = true

  NewObject("Ship")
  NewObject("Player")
end