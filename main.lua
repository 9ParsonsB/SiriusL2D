Events = require "Engine/events"
Renderer = require "Engine/renderer"
GameState = require "Engine/gameState"

local function Entity(filePath, ...)
    local env = setmetatable({}, {__index=_G})
    assert(loadfile(filePath, 't', env))()
    env.Create(...)
    return env
end

local test = Entity("Game/test.lua", 100, 100)

function love.load()
    love.graphics.setBackgroundColor(104, 136, 248)
    love.physics.setMeter(64)
    World = love.physics.newWorld(0, 0, true)
end

function love.update(dt)
    GameState:Update(dt)
    World:update(dt)
    test.Update(dt)
end

function love.draw()
    GameState:Draw()
    test.Draw()
end