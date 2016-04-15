Object("Game")

Game.Player1Score = 0
Game.Player2Score = 0

function Game:Ui()
  --Score
  Ui.Label(self.Player1Score, 250, 100)
  Ui.Label(self.Player2Score, 1024 - 250, 100)

  --Debug
  Ui.Label("FPS: " .. love.timer.getFPS(), self.X, self.Y)
end

function Game:KeyPressed(key)
  if key == "f3" then self.Active = not self.Active end
end