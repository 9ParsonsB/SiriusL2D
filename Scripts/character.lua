function Create(self)
  self.Health = 0
  self.MoveSpeed = 300
end

function ApplyDamage(self, damage)
  self.Health = math.max(self.Health - damage, 0)
end