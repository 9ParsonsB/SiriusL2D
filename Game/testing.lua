Paused = false

function Update(dt)
  if love.keyboard.isDown("space") then
	if Paused then Object.PlayScreen("Game")
  	else Object.PauseScreen("Game") end
	Paused = not Paused
  end
end