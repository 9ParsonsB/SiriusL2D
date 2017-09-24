require "core"

function ge.load()
  scene = ge.Scene("Noughts and crosses", 1024, 768)
  grid = ge.Grid(40, 40, 3, 3)
  grid.position = Vec(200, 200)
  turn = 0
end

function ge.update(dt)
  if ge.pressed(1) then
    local value, row, col = grid:cell(ge.mouse())
    if not value then
      grid[row][col] = turn + 1
      ge.endTurn()
    end
    --[[local cell = grid:cell(ge.mouse())
    if cell.value == 0 then
      cell.value = turn
    end--]]
  end

  if ge.pressed("r") then
    turn = 0
  end
end

function ge.draw()
  ge.push(grid)
  ge.drawGrid(0, 0, 100, 100, 3, 3)
  for i=0,3 do
    for j=0,3 do
      local v = grid[i][j]
      if v == 1 then ge.circle("line", 20 + (i * 40), 20 + (j * 40), 20) end
      if v == 2 then ge.line(0, 0, 40, 40) end
    end
  end
  ge.push()
  ge.print("Turn: " .. turn, 900, 20)
end

function ge.endTurn()
  ge.check(1, 2, 3)
  ge.check(4, 5, 6)
  ge.check(7, 8, 9)
  ge.check(1, 4, 7)
  ge.check(2, 5, 8)
  ge.check(3, 6, 9)
  ge.check(1, 5, 9)
  ge.check(3, 5, 7)
  turn = 1 - turn
end

function ge.check(a, b, c)
  --[[if grid[a] == turn and grid[b] == turn and grid[c] == turn then
  	reset = true
  end--]]
end
