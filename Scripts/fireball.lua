Class("Fireball")

Fireball.VelY = -100

function Fireball:Create()
  Scene.Add(self)
end

function Fireball:Draw()
  Renderer.Sprite("greyRect.png", self.X, self.Y)
end


Class("SpawnFireball", Ability)

SpawnFireball.Cooldown = 10

function SpawnFireball:Activate()
  local fireball = Fireball()
  fireball.X, fireball.Y = self.Player.X, self.Player.Y
  fireball.VelX = fireball.VelX + self.Player.VelX
  fireball.VelY = fireball.VelY + self.Player.VelY
end