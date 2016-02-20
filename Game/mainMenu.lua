Class("MainMenu")

function MainMenu:Create()
  Engine.Add(self, "MainMenu")
end

function MainMenu:GUI()
  if GUI.Button("greenRect.png", 250, 250, 100, 20) then
  	print("Button pressed")
  end
end