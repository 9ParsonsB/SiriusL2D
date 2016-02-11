Speed = 300

function Create(x, y)
  Body = love.physics.newBody(Physics.World, x or 0, y or 0, "dynamic")
  --Body:setFixedRotation(true)
  Shape = love.physics.newRectangleShape(16, 16)
  Fixture = love.physics.newFixture(Body, Shape)
  Fixture:setUserData(self)
end

function Update(dt)
  if not Physics.Active then return end

  local x, y = Body:getLinearVelocity()

  --WASD movement
  if love.keyboard.isDown("w") then y = y - Speed * dt end
  if love.keyboard.isDown("s") then y = y + Speed * dt end
  if love.keyboard.isDown("a") then x = x - Speed * dt end
  if love.keyboard.isDown("d") then x = x + Speed * dt end

  Body:setLinearVelocity(x, y)
end

function KeyPressed(key)
  if key == "1" then Physics.Active = not Physics.Active end
  if key == "2" then Physics.Debug = not Physics.Debug end
end

function Draw()
  Renderer.DrawSprite("greenRect.png", Body:getX(), Body:getY(), (180 / math.pi) * Body:getAngle())
end

function CollisionEnter(a, b, coll)
  print("Collision enter")
end

function CollisionExit(a, b, coll)
  print("Collision exit")	
end

function Sync(object)
  
end