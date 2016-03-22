Selected = nil

function MousePressed(self, x, y, button, isTouch)
  if button ~= 1 then return end

  --Unit selection
  local objects = GetObjects("Player") or {}
  for k,v in pairs(objects) do
  	if Select(v, x, y) then return end
  end

  --Movement control
  if Selected then Movement(Selected, x, y) end
end

function Select(self, x, y)
  if x >= self.X and x <= self.X + 16 and y >= self.Y and y <= self.Y + 16 then
  	if Selected == self then Selected = nil return end
  	Selected = self
  	return true
  end
end

function Movement(self, x, y)
  if self.TargetSet then 
    self.MoveToTarget = true
  else
  	self.TargetX, self.TargetY = x, y
  	self.DirX, self.DirY = Vector.Normalize(self.TargetX - self.X, self.TargetY - self.Y)
  	self.TargetSet = true
  end
end