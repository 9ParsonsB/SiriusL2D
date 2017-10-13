require "core"
require "menu"

local Unit = class("Unit", ge.Node)
function Unit:init(x, y, player, sprite, type)
	self.position = ge.Vector2(x, y)
	self.origin = self.position
	self.sprite = sprite
	self.player = player
	self.type = type
	self.inHand = true
	self.health = 7
	self.attack = 4
end

local Game = ge.State("game")
function Game:Load()
	print("Load game")
	self.unit1 = ge.Texture("res/unit1.png")
	self.unit2 = ge.Texture("res/unit2.png")
	self.ship1 = ge.Texture("res/mothership1.png")
	self.ship2 = ge.Texture("res/mothership2.png")
	self.units = ge.List()
	self.grid = ge.MpGrid(212, 160, 10, 7)
	self.turn = 0
	self.unit = nil

	-- units
	for i = 0, 3 do 
		self.units:add(Unit(438 + (i * 50), 100, 0, self.unit1, 0))
	end

	for i = 0, 3 do 
		self.units:add(Unit(438 + (i * 50), 500, 1, self.unit2, 0))
	end
	
	self.units:add(Unit(80, 300, 0, self.ship1, 1))
	self.units:add(Unit( 950, 300, 1, self.ship2, 1))
end

function Game:Drop(unit)
	local result = self.grid:add(unit)
	if not result then
		unit.position = unit.origin
	else
		unit.inHand = false
	end
end

-- if clicked on enemy attack else move to target
function Game:Move(unit, target)
	local enemy = self.units:getNode(target)
	if enemy and enemy ~= unit then

		enemy.health = math.max(enemy.health - unit.attack, 0)
		if enemy.health == 0 then
			if enemy.type == 1 then 
				gui.play("restart")
			end
			self.units:remove(enemy)
		end
	else
		unit.position = target
		self.grid:add(unit)
	end
end

function Game:EndTurn()
	self.turn = 1 - self.turn
end

function Game:Compare(unit)
	if unit.player == self.turn and unit.type == 0 then
		self.unit = unit
	end
end

function Game:Update(dt)
	-- select unit
	if ge.pressed(1) then
		self.units:select(self, Game.Compare)
	end

	-- drag unit
	if self.unit and self.unit.inHand == true then
		self.unit.position = ge.mouse()
	end

	-- drop on grid or return to hand
	if ge.released(1) and self.unit and self.unit.inHand == true then
		self:Drop(self.unit)
		self.unit = nil
	end

	-- move/attack unit
	if ge.pressed(1) and self.unit and self.unit.inHand == false then
		local mouse = ge.mouse()
		self:Move(self.unit, mouse)
	end
end

function Game:Ui(dt)
	gui.begin("game", 880, 20, 200, 10)
	gui.label("Player turn " .. self.turn)
	
	gui.begin("game", 850, 500, 150, 50)
	if gui.button("End turn") then 
		self:EndTurn() 
	end

	if ge.pressed("escape") then 
		ge.play("menu") 
	end

	if gui.begin("restart", 312, 250, 400, 100)then
		if gui.button("Game over") then ge.restart() end
	end
end

function Game:Draw()
	self.units:draw()
	self.grid:draw(60, 40)

	if self.unit then
		local w, h = self.unit.sprite:getDimensions()
		ge.push(self.unit)
		ge.rectangle("line", -w/2,-h/2, w, h)
	end
end