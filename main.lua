require "Engine/engine"

Engine.SetState("MainMenu")

local button = Ui.Button(0, 0, 100, 20)
button.Texture = "greyRect.png"
button.Hover = "greenRect.png"
button.OnClick = function () 
  print("Pressed") 
end