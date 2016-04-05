require "Engine"

--Load scripts
Script.Load("debug")
Script.Load("cameraControl")
Script.Load("unitSystem")
Script.Load("unit")
Script.Load("player")
Script.Load("enemy")

--Create objects
Instance("Debug", 0, 0)
Instance("CameraControl", 0, 0)
--Instance("UnitSystem", 0, 0)
--Instance("GenericUnit", 0, 0)
Instance("Player", 0, 0)
Instance("Enemy", 200, 0)