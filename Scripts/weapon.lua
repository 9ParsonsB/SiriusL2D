Class("Weapon")

function Weapon:Create()
  Scene.Add(self)
end

Class("PlayerWeapon", Weapon)


Class("EnemyWeapon", Weapon)