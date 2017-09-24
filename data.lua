
data = {
	unit = {},
	weapon = {},

	binds = 
	{
		SELECT = 1,
		COMMAND = 2,
		SPAWN = "1",
		TEST = "t"
	}
}

data.player = class("Player", {
	minerals = 0,
	vespene = 0,
	supply = 0})

data.unit.Scout = class("Scout", {
	sprite = "unit1",
	health = 50,
	shield = 25})

data.unit.Fighter = class("Fighter", {
	sprite = "unit2",
	health = 100,
	shield = 50})

data.unit.Dreadnought = class("Dreadnought", {
	sprite = "unit2",
	health = 200,
	shield = 100})

data.weapon.Laser = class("Laser", {
	damage = 20,
	cooldown = 2})

-- modding example
local mod = {}
mod.name = "Generic Dirt"
mod.author = "Generic Author"
mod.version = "1.0"
mod.info = "Generic Info"

function mod.load(data)
	data.resources = 100
  data.Vulture = class("Vulture")
  table.insert(data.units, data.Vulture)
end
