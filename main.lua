require "Engine/engine"
require "Game/Network/client"

Engine.SetState("MainMenu")

--Ui style
Ui.Button.Texture = "greyRect.png"
Ui.Button.Hover = "greenRect.png"

local singlePlayer = Ui.Button(250, 300, 100, 20, "Single Player")
function singlePlayer:Click()
  Engine.Client:Start()
end

local multiplayer = Ui.Button(250, 340, 100, 20, "Multiplayer")
function multiplayer:Click() 
  Engine.Server:Start()
end

local test = Ui.TextBox(250, 360, 100, 20)
function test:TextEntered(t)

end