FireRate = 0.1
Timer = 0
Speed = 300

function Create(x, y)
    X = x or 0
    Y = y or 0
    Angle = 0

    Events.Register("Fire", Fire)
end

function Update(dt)
    if love.keyboard.isDown("space") then Events.Fire("Fire", dt) end
    if love.keyboard.isDown("w") then Y = Y - Speed * dt end
    if love.keyboard.isDown("s") then Y = Y + Speed * dt end
    if love.keyboard.isDown("a") then X = X - Speed * dt end
    if love.keyboard.isDown("d") then X = X + Speed * dt end
end

function Draw()
    Renderer.DrawSprite("greenRect.png", X, Y, Angle)
    Renderer.DrawText("FPS: " .. love.timer.getFPS())
end

function Fire(dt)
    Timer = Timer + dt
    if Timer > FireRate then
        print("Firing")
        Timer = 0
    end
end
// Test