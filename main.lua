require "Engine"

--Load scripts
Script.Load("camera")
Script.Load("debug")
Script.Load("unitSystem")
Script.Load("unit")
Script.Load("player")

--Create objects
Instance("Debug", 0, 0)
--Instance("Player", 0, 0)

--Instance("UnitSystem", 0, 0)
for i = 1, math.random(15, 30) do
  Instance("GenericUnit", math.random(-400, 400), math.random(-300, 300))
end