require "core"

function ge.load()
	scene = ge.Scene("Sirius", 1024, 768)
  unit1 = ge.Texture("res/unit1.png")
  unit2 = ge.Texture("res/unit2.png")
 	hero1 = ge.Texture("res/mothership1.png")
  hero2 = ge.Texture("res/mothership2.png")
  units = ge.List()
  grid = ge.Grid(10, 7)
  turn = 0

  -- player 1
  for i=0,3 do 
 		units:add(nil, 400 + (i * 50), 100, 0)
 		units[#units].health = 30
  end

  -- player 2
  for i=0,3 do 
  	units:add(nil, 400 + (i * 50), 700, 0)
  end
end

function ge.move(unit, position)
	local enemy = grid[position]
	if enemy then
		enemy.health = enemy.health - unit.attack
		-- if enemy hero killed then
		--   game over
    --   reset()
		-- end
  -- move on grid
	else
		grid:snap(unit)
	end

	turn = 1 - turn
  unit.selected = false
end

function ge.update(dt)
  -- select units
 	if ge.pressed(1) then 
    unit = units:select(ge.mouse(), unit1, true)
  end

  -- process move
  if ge.pressed(1) and unit then
    if unit.grid then
      ge.move(unit, ge.mouse())
    end
    -- units:snap(32, 32, 0);
  end

  -- place unit on grid
  if ge.released(1) and unit then
    -- if not unit.grid then unit.grid = true end
    unit.selected = false
    unit = nil
  end

  -- drag units
	if unit then
		unit.position = ge.mouse()
	end
end

function ge.draw()
  ge.drawGrid(210, 200, 60, 40, 10, 7)
  ge.render(hero1, 20, 300)
  ge.render(hero2, 850, 300)
  ge.print("Player Turn: " .. turn + 1, 880, 30)

  local w, h = unit1:getDimensions()
  for k,v in pairs(units) do
  	ge.push(v)
  	ge.render(unit1, 0, 0, v.r, 1, 1, w / 2, h / 2)
   	if v.selected then
      ge.rectangle("line", -w / 2, -h / 2, w, h)
    end
  end

  local info = unit or {}
  ge.push()
  ge.print("Attack Health Shield", 20, 650)
  ge.print((info.attack or 0) .. " " .. (info.health or 0) .. " " .. (info.shield or 0), 20, 680)
end
