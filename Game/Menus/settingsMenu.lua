local Settings = Ui.Menu("Settings")

Settings.Active = false

function Settings:Update(dt)
  self:Label("Settings", 200,200, 100, 20)

  --Return to main menu
  if love.keyboard.isDown("escape") then
    self:Disable()
    self:Enable("Main")
  end
end