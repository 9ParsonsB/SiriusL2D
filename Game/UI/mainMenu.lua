local MainMenu = Class("MainMenu")

function MainMenu:Create()
  self.Connect = Ui.Button(200, 400, 100, 20, "Connect")
  self.StartServer = Ui.Button(200, 430, 100, 20, "Start server")
  self.Settings = Ui.Button(200, 460, 100, 20, "Settings")
  self.Quit = Ui.Button(200, 490, 100, 20, "Quit")

  self.InGame = false
  Engine.Add(self, "MainMenu")
end

--Quit game when escape pressed
function MainMenu:KeyPressed(key)
  if key == "escape" then love.event.quit() end
end

--Handle button presses
function MainMenu:MousePressed(x, y, button, isTouch)
  if self.Connect.Pressed then 
    Engine.Client:Start()
    local packet = Engine.Client:Packet("Hello world!")
    Engine.Client:SendPacket(packet,"127.0.0.1")
    self.Connect:Disable() 
  end

  if self.StartServer.Pressed then 
    Engine.Server:Start() 
    self.StartServer:Disable() 
  end

  if self.Settings.Pressed then 
    Engine.SetState("SettingsMenu") 
  end

  if self.Quit.Pressed then 
    love.event.quit() 
  end
end

function MainMenu:StartGame()
  Engine.SetState("Game")
  if self.InGame then return end
  self.InGame = true
end
return MainMenu