Class("StartButton", "Button")

StartButton.Width = 150
StartButton.Height = 50
StartButton.State = "MainMenu"
StartButton.Text = "StartGame"
StartButton.Start = true

function StartButton:PressedButton() 
  Engine.SetState("Game")

  --Start game once
  if self.Start then
  	self:StartGame()
  	self.Start = false
  end
end

function StartButton:EnteredButton()
  self.Texture = "blueRect.png"
end

function StartButton:LeftButton()
  self.Texture = "greenRect.png"
end

function StartButton:StartGame()
  print("Starting game...")

  NewObject("Ship")
  NewObject("Player")
  --NewObject("Box", 400, 250, 700, 50)
  NewObject("Debug")
end