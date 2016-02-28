local MainMenu = Ui.Menu("Main")
function MainMenu:Update(dt)
  self:Label("Main menu", 200,200, 100, 20)

  if self:Button("Connect", 200,250, 100, 20).Pressed then
    print("Connecting...")

    --Create client
    Network.Peer = Network.Client('TEMPCLIENT1')
    Network.Peer:Start()
    Network.Peer:Connect("siriusgame.ddns.net")
  end

  if self:Button("Start server", 200,280, 100, 20).Pressed then
    print("Starting server...")

    --Create server
    Network.Peer = Network.Server('TEMPCLIENT1')
    Network.Peer:Start() 
  end

  if self:Button("Settings", 200,310, 100, 20).Pressed then
    self:Disable()
    self:Enable("Settings")
  end

  --Quit button pressed
  if self:Button("Quit", 200,340, 100, 20).Pressed then
    love.event.quit()
  end
end

--Bug when quitting settings menu, escape key instantly fires
function MainMenu:KeyPressed(key)
  --Quit if escape pressed
  if key == "escape" then love.event.quit() end
end