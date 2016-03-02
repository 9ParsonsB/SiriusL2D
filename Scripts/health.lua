function Create(health)
  Health = health or 0
end

function ApplyDamage(damage)
  Health = Health - damage
  Health = math.min(Health, 0)
end