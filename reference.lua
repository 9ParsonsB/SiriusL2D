Events = class("Events")
Events.Handlers = {}
Events.HandlerCounts = {}

function Events.Register(trigger, handler)
	if type(handler) ~= "function" then return end

	--Create empty table and count if trigger not registered before
	Events.Handlers[trigger] = Events.Handlers[trigger] or {}
	Events.HandlerCounts[trigger] = Events.HandlerCounts[trigger] or 0

	--Store handler
	Events.Handlers[trigger][Events.HandlerCounts[trigger]] = handler
	Events.HandlerCounts[trigger] = Events.HandlerCounts[trigger] + 1
end

function Events.Fire(trigger, ...)
	if not Events.Handlers[trigger] then return end
	for k, v in pairs(Events.Handlers[trigger]) do
		v(...)
	end
end

function love.mousepressed(x, y, button, istouch)
   if button == 1 then 
      objects[boxCount] = {}
      local box = objects[boxCount]

      box.body = love.physics.newBody(world, x, y, "dynamic")
      box.shape = love.physics.newRectangleShape(10, 10)
      box.fixture = love.physics.newFixture(box.body, box.shape);

      boxCount = boxCount + 1
   end
end

--World
--[[love.physics.setMeter(64)
world = love.physics.newWorld(0, 9.81*64, true)

--Physics objects
objects = {}
boxCount = 1

--Ground
objects.ground = {}
objects.ground.body = love.physics.newBody(world, 512, 700)
objects.ground.shape = love.physics.newRectangleShape(1024, 10)
objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape);

--Particle system
psystem = love.graphics.newParticleSystem(sprite, 32)
psystem:setParticleLifetime(2, 5)
psystem:setEmissionRate(100)
psystem:setSizeVariation(1)
psystem:setLinearAcceleration(-5, -5, 5, 5)
psystem:setColors(255, 255, 255, 255, 255, 255, 255, 0)--]]