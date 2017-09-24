
function love.load()
  --world
  love.physics.setMeter(64) 
  world = love.physics.newWorld(0, 9.84 * 64, true)
  world:setCallbacks(nil, love.endContact, nil, nil)

  --bat
  bat = {}
  bat.body = love.physics.newBody(world, 1024 / 2, 768 - 50, "kinematic")
  bat.shape = love.physics.newRectangleShape(120, 20)
  bat.fixture = love.physics.newFixture(bat.body, bat.shape)

  --ball
  ball = {}
  ball.body = love.physics.newBody(world, 1024 / 2, 768 / 2, "dynamic")
  ball.shape = love.physics.newCircleShape(10)
  ball.fixture = love.physics.newFixture(ball.body, ball.shape, 1)
  ball.fixture:setRestitution(1)  
  ball.body:setLinearVelocity(0, 500)
  ball.body:setFixedRotation(true)

  --walls
  walls = {}

  walls[1] = {}
  walls[1].body = love.physics.newBody(world, 0, 768 / 2, "static")
  walls[1].shape = love.physics.newRectangleShape(5, 768)
  walls[1].fixture = love.physics.newFixture(walls[1].body, walls[1].shape)

  walls[2] = {}
  walls[2].body = love.physics.newBody(world, 1024, 768 / 2, "static")
  walls[2].shape = love.physics.newRectangleShape(5, 768)
  walls[2].fixture = love.physics.newFixture(walls[2].body, walls[2].shape)

  walls[3] = {}
  walls[3].body = love.physics.newBody(world, 1024 / 2, 0, "static")
  walls[3].shape = love.physics.newRectangleShape(1024, 5)
  walls[3].fixture = love.physics.newFixture(walls[3].body, walls[3].shape)

  --blocks
  blocks = {}

  local x, y = 105, 100
  for i = 1, 7 do 
    for j = 1, 11 do
      love.addblock(x, y, 70, 30) 
      x = x + 80
    end
    x = 105
    y = y + 40
  end
end

function love.addblock(x, y, w, h)
  local block = {}

  table.insert(blocks, block)

  block.id = #blocks
  block.tag = "block"
  block.body = love.physics.newBody(world, x, y, "static")
  block.shape = love.physics.newRectangleShape(w, h)
  block.fixture = love.physics.newFixture(block.body, block.shape)
  block.fixture:setUserData(block)
end

function love.removeblock(block)
  block.body:destroy()
  blocks[block.id] = blocks[#blocks]
  blocks[#blocks].id = block.id
  table.remove(blocks, #blocks)
end

function love.endContact(a, b, coll)
  local obj = a:getUserData() or {}
  local other = b:getUserData() or {}
  if obj.tag == "block" then love.removeblock(obj) end
end

function love.update(dt)
  world:update(dt)

  --move bat left and right
  bat.body:setLinearVelocity(0, 0) 
  if love.keyboard.isDown("a") then bat.body:setLinearVelocity(-800, 0) end
  if love.keyboard.isDown("d") then bat.body:setLinearVelocity(800, 0) end

  --ball moves at a constant velocity
  local x, y = ball.body:getLinearVelocity()
  --if x > 0 then x = math.max(x, 10) else x = math.min(x, -10) end
  if y > 0 then y = 700 else y = -700 end
  ball.body:setLinearVelocity(x, y)

  --reset ball
  local x, y = ball.body:getPosition()
  if y > 768 then
    ball.body:setPosition(1024 / 2, 768 / 2)
    ball.body:setLinearVelocity(0, 500)
  end
end

function love.draw()
  --draw bat
  love.graphics.setColor(72, 160, 14) 
  love.graphics.polygon("fill", bat.body:getWorldPoints(bat.shape:getPoints()))
 
  --draw ball
  love.graphics.setColor(193, 47, 14)
  love.graphics.circle("fill", ball.body:getX(), ball.body:getY(), ball.shape:getRadius())

  --draw blocks
  love.graphics.setColor(0, 102, 204) 
  for k, v in pairs(blocks) do
    love.graphics.polygon("fill", v.body:getWorldPoints(v.shape:getPoints()))
  end
end
