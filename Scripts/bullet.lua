function Create(self)
  self.Timer = Timer.Create(3)
  self.Collider = Physics.Collider(self, "dynamic", "box", 16, 16)
  self.Collider:SetLinearVelocity(-340, 0)
  self.Collider.Body:setFixedRotation(true)
  self.Collider.Fixture:setSensor(true)
end

function Update(self, dt)
  self.X, self.Y = self.Collider:GetPosition()
  if self.Timer.Active then Destroy(self) end
end

function Draw(self)
  Renderer.Sprite("greenRect.png", self.X, self.Y)
  self.Collider:Draw()
end

function CollisionEnter(self, other)
  --if other.Name == "Player" then
    --Destroy(other) 
    --Destroy(self)
  --end
  print("Bullet hit " .. other.Name)
end