Class("Ability")

Ability.Cooldown = 0
Ability.Timer = 0
Ability.Key = ""
Ability.Active = false

function Ability:Create(player, key)
  Scene.Add(self)
  self.Player = player
  self.Key = key
end

function Ability:Update(dt)
  self.Timer = math.max(self.Timer - dt, 0)
  self.Active = self.Timer == 0
end

function Ability:Ui()
  Ui.Label(string.format("Cooldown %i", self.Timer), 0, 100, 100)
end

function Ability:KeyPressed(key)
  if key == self.Key and self.Active then
    self:Activate()
    self.Active = false
    self.Timer = self.Cooldown
  end
end

function Ability:Activate() end