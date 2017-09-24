require "core"

function ge.load()
  scene = ge.Scene("sirius", 1024, 768)
  
  ge.physics.setMeter(64) 
  world = ge.physics.newWorld(0, 9.84 * 64, true)
  world:setCallbacks(nil, ge.endContact, nil, nil)

  bat = ge.Node(nil, 0, 0, 0)
  bat.body = ge.physics.newBody(world, 1024 / 2, 768 - 50, "kinematic")
  bat.shape = ge.physics.newRectangleShape(120, 15)
  bat.fixture = ge.physics.newFixture(bat.body, bat.shape)

  ball = ge.Node(nil, 0, 0, 0)
  ball.body = ge.physics.newBody(world, 1024 / 2, 768 - 100, "dynamic")
  ball.shape = ge.physics.newCircleShape(10)
  ball.fixture = ge.physics.newFixture(ball.body, ball.shape, 1)
  ball.fixture:setRestitution(1)  
  ball.body:setLinearVelocity(0, 500)
  ball.body:setFixedRotation(true)

  walls = ge.List(3, nil)
  walls[1].body = ge.physics.newBody(world, 0, 768 / 2, "static")
  walls[1].shape = ge.physics.newRectangleShape(5, 768)
  walls[1].fixture = ge.physics.newFixture(walls[1].body, walls[1].shape)

  walls[2] = {}
  walls[2].body = ge.physics.newBody(world, 1024, 768 / 2, "static")
  walls[2].shape = ge.physics.newRectangleShape(5, 768)
  walls[2].fixture = ge.physics.newFixture(walls[2].body, walls[2].shape)

  walls[3] = {}
  walls[3].body = ge.physics.newBody(world, 1024 / 2, 0, "static")
  walls[3].shape = ge.physics.newRectangleShape(1024, 5)
  walls[3].fixture = ge.physics.newFixture(walls[3].body, walls[3].shape)

  blocks = ge.List()
  for y = 0, 4 do 
    for x = 0, 15 do
      local px, py = 120 + (x * 52), 100 + (y * 32)
      local block = blocks:add(nil, px, py, 0)
      block.tag = "block"
      block.body = ge.physics.newBody(world, px, py, "static")
      block.shape = ge.physics.newRectangleShape(50, 15)
      block.fixture = ge.physics.newFixture(block.body, block.shape)
      block.fixture:setUserData(block)
    end
  end
end

function ge.removeblock(block)
  block.body:destroy()
  blocks:remove(block)
end

function ge.endContact(a, b, coll)
  local obj = a:getUserData() or {}
  local other = b:getUserData() or {}
  if obj.tag == "block" then ge.removeblock(obj) end
end

function ge.update(dt)
  world:update(dt)
  bat.body:setLinearVelocity(0, 0) 
  if ge.down("a") then bat.body:setLinearVelocity(-800, 0) end
  if ge.down("d") then bat.body:setLinearVelocity(800, 0) end

  -- ball moves at a constant velocity
  local x, y = ball.body:getLinearVelocity()
  if y > 0 then y = 700 else y = -700 end
  ball.body:setLinearVelocity(x, y)

  -- reset ball
  local x, y = ball.body:getPosition()
  if y > 768 then
    ball.body:setPosition(1024 / 2, 768 / 2)
    ball.body:setLinearVelocity(0, 500)
  end
end

function ge.draw()
  ge.setColour(72, 160, 14) 
  ge.polygon("fill", bat.body:getWorldPoints(bat.shape:getPoints()))
  ge.setColour(193, 47, 14)
  ge.circle("fill", ball.body:getX(), ball.body:getY(), ball.shape:getRadius())
  ge.setColour(0, 102, 204) 
  for k, v in pairs(blocks) do
    ge.polygon("fill", v.body:getWorldPoints(v.shape:getPoints()))
  end
end
