Object("Ball")

Ball.Texture = "greenRect.png"

Ball.UsePhysics = true
Ball.Shape = "circle"
Ball.Radius = 8
Ball.Restitution = 1
Ball.FixedRotation = true

Ball.InitialSpeed = 500
Ball.MaxSpeed = 1500
Ball.Paused = true

function Ball:Create()
  Bat.Ball = self
  self.Speed = Vector(self.InitialSpeed, 0)
end

function Ball:Update(dt)
  --Maintain constant speed
  local x, y = self:GetLinearVelocity()
  if x < 0 then self:SetLinearVelocity(-self.Speed.X, y) end
  if x > 0 then self:SetLinearVelocity(self.Speed.X, y) end

  --Player 1 scores
  if self.Position.X > 512 then
    Game.Player1Score = Game.Player1Score + 1
    self:Reset()
  end

  --Player 2 scores
  if self.Position.X < -512 then
    Game.Player2Score = Game.Player2Score + 1
    self:Reset()
  end
end

--Accelerate ball over time
function Ball:CollisionEnter(other, coll)
  if other.Name == "Bat" then self.Speed.X = math.min(self.Speed.X + 50, self.MaxSpeed) end
end

--Reset ball to start
function Ball:Reset()
  self:SetLinearVelocity(0, 0)
  self:Teleport(0, 0)
  self.Paused = true
  Game.Paused = true
end

--Start ball
function Ball:KeyPressed(key)
  if key == "space" and self.Paused then 
    self.Paused = false 
    self.Speed = Vector(self.InitialSpeed, 0)
    self:SetLinearVelocity(self.Speed.X, self.Speed.Y) 
  end
end