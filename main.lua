require "Engine"

Physics.Debug = false

--Load files
local Ball = LoadEntity("Objects/ball")
local Player = LoadEntity("Objects/player")

local Movement = LoadScript("Scripts/movement")
local Track = LoadScript("Scripts/track")

--Create objects
local width, height = love.graphics.getDimensions()

local ball = Create(Ball, width / 2, height / 2)

--local p1 = Create(Player, 20, 100)
--p1:AddScript(Movement, 300)

--local p2 = Create(Player, 988, 100)
--p2:AddScript(Track, ball)