--Load scripts
Script.Load("Pong/camera")
Script.Load("Pong/game")
Script.Load("Pong/wall")
Script.Load("Pong/bat")
Script.Load("Pong/ball")

--Create objects
Instance("Game", 0, 0)
Instance("Wall", 0, -384)
Instance("Wall", 0, 384)
Instance("Ball", 0, 0)
Instance("Bat", -500, 0)
Instance("Bat", 500, 0)

--CD some strange physics issues that seem to fix when the physics
--metre is increased. Will probably return at the worst time :(
