require "core"
ge.load("menu", true)
ge.load("data", true)

local Unit = class("unit")
function Unit:init(name)
  local data = data[name]
  self.name = name
  self.health = data.health
  self.attack = data.attack
end

function Unit:draw()
	ge.push(self)
	ge.drawf(data[self.name].file)
end

function game()

end