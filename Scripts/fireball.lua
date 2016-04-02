Class("Fireball")

Fireball.Texture = "greyRect.png"
--Fireball.VelY = -100

function Fireball:Create()
  Scene.Add(self)
end

Class("SpawnFireball", Ability)

SpawnFireball.Cooldown = 10

function SpawnFireball:Activate()
  local fireball = Fireball()
  fireball.X, fireball.Y = self.Player.X, self.Player.Y
  fireball.VelX = fireball.VelX + self.Player.VelX
  fireball.VelY = fireball.VelY + self.Player.VelY
end