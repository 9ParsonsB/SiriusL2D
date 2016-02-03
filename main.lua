Renderer = require "Engine/renderer"
GameState = require "Engine/gameState"

local function CreateEntity(scriptfile, ...)
    local env = setmetatable({}, {__index=_G})
    assert(loadfile(scriptfile, 't', env))()
    env.Create(...)
    return env
end

local test = CreateEntity("Game/test.lua")

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