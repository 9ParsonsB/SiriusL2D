require "Engine"

--NOTE: load order matters. If class A inherits from class B, then class B must be loaded first

Script.Load("Scripts/entity")

--Rooms
Script.Load("Scripts/room")
Script.Load("Scripts/pilotRoom")

--Ships
Script.Load("Scripts/ship")
Script.Load("Scripts/genericEnemy")
Script.Load("Scripts/player")

Script.Load("Scripts/init")