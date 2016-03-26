require "Engine"

--Load scripts
Scripts.Game = LoadScript("Scripts/game")
Scripts.Path = LoadScript("Scripts/path")
Scripts.Player = LoadScript("Scripts/player")
Scripts.Movement = LoadScript("Scripts/movement")

--Load objects
Objects.Game = LoadObject("Objects/game")
Objects.Player = LoadObject("Objects/player")

--Create objects
Instance("Game", 0, 0)
Instance("Player", 200, 200)