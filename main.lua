local GameState = require "Engine/gameState"
local Camera = require "Engine/camera"

local DebugInfo = require "Game/debugInfo"
local Ship = require "Game/ship"
local Player = require "Game/player"
local Wall = require "Game/wall"

function love.load()
    love.graphics.setBackgroundColor(104, 136, 248)
    love.physics.setMeter(64)
    World = love.physics.newWorld(0, 0, true)

    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    --Set screen cameras
    GameState:SetCamera(Camera(0, 0), "Game")

    --Game objects
    DebugInfo(0, 0)
    --local ship1 = Ship(300, 300, 0)
    local player1 = Player((width / 2) - 25, (height / 2) - 25, 300)
    --local wall1 = Wall(300, 200)
end

function love.update(dt)
    GameState:Update(dt)
    World:update(dt)
end

function love.draw()
    GameState:Draw()
end