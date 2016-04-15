Object("Bat")

Bat.Texture = "greyRect.png"

Bat.UsePhysics = true
Bat.Type = "kinematic"
Bat.Width = 10
Bat.Height = 100
Bat.FixedRotation = true
Bat.Restitution = 1

Bat.MoveSpeed = 400

function Bat:Create()
  self.Team = #Scene.GetObjects("Bat")
end

function Bat:Update(dt)
  if self.Team == 0 then self:MovementControl(dt)
  else self:TrackBall(dt) end
end

function Bat:MovementControl(dt)
  if love.keyboard.isDown("w") then self.Position.Y = self.Position.Y - self.MoveSpeed * dt end
  if love.keyboard.isDown("s") then self.Position.Y = self.Position.Y + self.MoveSpeed * dt end
end

function Bat:TrackBall(dt)
  if self.Ball then
    local distance = self.Ball.Position.Y - self.Position.Y

  	if distance < 0 then
  	  self.Position.Y = self.Position.Y - self.MoveSpeed * dt
  	elseif distance > 0 then
  	  self.Position.Y = self.Position.Y + self.MoveSpeed * dt
  	end
  end   
end