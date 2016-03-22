function Create(self)
  self.TargetX, self.TargetY = 0, 0
  self.TargetSet = false
  self.MoveToTarget = false
  self.MoveSpeed = 300
end

function Update(self, dt)
  if not Scripts.Game.Paused and self.MoveToTarget then MoveToTarget(self, dt) end
end

function MoveToTarget(self, dt)
  local distX, distY = self.TargetX - self.X, self.TargetY - self.Y

  --Move towards target
  local moveX, moveY = self.DirX * self.MoveSpeed * dt, self.DirY * self.MoveSpeed * dt
  self.X = self.X + moveX
  self.Y = self.Y + moveY

  --Stop when target is reached
  if math.abs(moveX) >= math.abs(distX) or math.abs(moveY) >= math.abs(distY) then
  	self.X, self.Y = self.TargetX, self.TargetY
  	self.TargetSet = false
  	self.MoveToTarget = false
  end
end

function Draw(self)
  if self.TargetSet then love.graphics.line(self.X, self.Y, self.TargetX, self.TargetY) end
end

function MousePressed(self, x, y, button, isTouch)
  --Cancel movement path
  if button == 2 and Scripts.UnitSystem.Selected then
  	self.TargetSet = false
  	self.MoveToTarget = false
  end
end