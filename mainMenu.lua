--Ui style
Ui.Button.Texture = "greyRect.png"
Ui.Button.Hover = "greenRect.png"

SinglePlayer = Ui.Button(250, 300, 100, 20, "Single Player")
function SinglePlayer:Click()
  print("Single player...") 
  --Engine.SetState("Game")
end

Multiplayer = Ui.Button(250, 340, 100, 20, "Multiplayer")
function Multiplayer:Click()
  print("Multiplayer...") 
  --Engine.SetState("Game")
end