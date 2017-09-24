require "core"

function ge.load()
	scene = ge.Scene("Traffic", 1024, 768)
	grid = ge.Grid(40, 40, 10, 7)
	grid.position = Vec(150, 150)
end

function ge.update(dt)
	local value, row, col = grid:cell(ge.mouse())
	if ge.down(1) then		
		grid[row][col] = 1
	end
	if ge.down(2) then
		grid[row][col] = 0
	end
end

function ge.draw()
	ge.push(grid)
	ge.setColour(0, 124, 0)
	for i=0,10 do
		for j=0,7 do
			local cell = grid[i][j]
			if cell == 1 then ge.rectangle("fill", i * 40, j * 40, 40, 40) end
		end
	end
	ge.setColour(255, 255, 255)
	ge.drawGrid(0, 0, 40, 40, 10, 7)
end
