local Game = Ui.Menu("Game")
function Game:Update(dt)
  --Display fps
  self:Label("FPS: " .. love.timer.getFPS(), 0,0, 100, 20)
end