function Create()
	x = 100
	y = 100
	angle = 0
	speed = 300
end
function Update(dt)
	if love.keyboard.isDown("w") then y = y - speed * dt end
	if love.keyboard.isDown("s") then y = y + speed * dt end
	if love.keyboard.isDown("a") then x = x - speed * dt end	
	if love.keyboard.isDown("d") then x = x + speed * dt end
end
function Draw()
	Renderer.DrawSprite("greenRect.png", x, y, angle)
	Renderer.DrawText("FPS: " .. love.timer.getFPS())
end