require "Engine"

--Load scripts
Script.Load("debug")
Script.Load("cameraControl")
Script.Load("unitSystem")
Script.Load("unit")
Script.Load("player")

--Create objects
Instance("Debug", 0, 0)
Instance("CameraControl", 0, 0)
Instance("UnitSystem", 0, 0)
Instance("GenericUnit", 0, 0)
Instance("GenericUnit", 200, 0)
--print(test:IsType("Unit"))