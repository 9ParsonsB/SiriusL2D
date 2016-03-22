--Load scripts
Scripts.Character = LoadScript("Scripts/character")
Scripts.Player = LoadScript("Scripts/player")

--Define objects
Objects.Player = Object("Player", "Character")

--Create objects
local player = Objects.Player(50, 50)