
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

data.player = gClass("Player", {
	minerals = 0,
	vespene = 0,
	supply = 0})

data.unit.Scout = gClass("Scout", {
	sprite = "unit1",
	health = 50})

data.unit.Fighter = gClass("Fighter", {
	sprite = "unit2",
	health = 100})

data.unit.Dreadnought = gClass("Dreadnought", {
	sprite = "unit2",
	health = 200})

data.weapon.Laser = gClass("Laser", {
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
