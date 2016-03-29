Transform = {
  Grid = require "Engine/Transform/grid"
}

function Transform.Len(x, y)
  return math.sqrt(x * x + y * y)
end

function Transform.Normalize(x, y)
  local len = Transform.Len(x, y)
  if len == 0 then len = 1 end

  x = x / len
  y = y / len
  return x, y
end

function Transform.GetDirection(self, object)
  local distX, distY = object.X - self.X, object.Y - self.Y
  return Transform.Normalize(distX, distY)
end

function Transform.FollowPath(self, path, speed)
  --Return if there is no path
  if #path == 0 then return end
  local dt = love.timer.getDelta()

  --Get distance to target
  local targetX, targetY = path[1].X, path[1].Y
  local distX, distY = targetX - self.X, targetY - self.Y

  --Get amount to move towards target
  local dirX, dirY = Transform.GetDirection(self, path[1])
  local speedX, speedY = dirX * speed * dt, dirY * speed * dt

  --Move towards target
  self.X = self.X + speedX
  self.Y = self.Y + speedY

  --Stop when target is reached
  if math.abs(speedX) >= math.abs(distX) and math.abs(speedY) >= math.abs(distY) then
    self.X, self.Y = targetX, targetY
    table.remove(path, 1)
  end
end

function Transform.MoveTo(self, targetX, targetY, speed)
  local dt = love.timer.getDelta()
  
  --Get distance to target
  local distX, distY = targetX - self.X, targetY - self.Y

  --Get amount to move towards target
  local dirX, dirY = Transform.GetDirection(self, {X = targetX, Y = targetY})
  local speedX, speedY = dirX * speed * dt, dirY * speed * dt

  --Move towards target
  self.X = self.X + speedX
  self.Y = self.Y + speedY

  --Stop when target is reached
  if math.abs(speedX) >= math.abs(distX) and math.abs(speedY) >= math.abs(distY) then
    self.X, self.Y = targetX, targetY
  end
end