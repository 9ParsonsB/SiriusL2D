local grid = {
  0, 0, 0,
  0, 0, 0,
  0, 0, 0
}

local pos = {
  {0, 0}, {200, 0}, {400, 0},
  {0, 200}, {200, 200}, {400, 200},
  {0, 400}, {200, 400}, {400, 400}
}

local cellWidth, cellHeight = 200, 200
local turn = 1
local reset = false
local line = {0, 0, 0}

function love.load()
  love.graphics.setBackgroundColor(100, 149, 237)
  nought = love.graphics.newImage("res/nought.png")
  cross = love.graphics.newImage("res/cross.png")
end

function love.draw()
  --draw grid state
  for k, v in pairs(grid) do
  	local cx, cy = pos[k][1], pos[k][2]
  	if v == 1 then love.graphics.draw(nought, cx, cy) end
  	if v == 2 then love.graphics.draw(cross, cx, cy) end
  end

  --draw winning move
  if reset then 
  	local x, y = pos[line[1]][1], pos[line[1]][2]
  	local x2, y2 = pos[line[2]][1], pos[line[2]][2]
  	local w, h = cellWidth / 2, cellHeight / 2
  	love.graphics.line(x + w, y + h, x2 + w, y2 + h) 
  end
end

function love.mousepressed(x, y, button)
  if button ~= 1 then return end

  --make a move when a cell is clicked
  for k, v in pairs(grid) do
  	local cx, cy = pos[k][1], pos[k][2]
  	if v == 0 and love.mouseover(x, y, cx, cy) then 
  	  love.move(k) 
  	end
  end
end

function love.mouseover(x, y, cx, cy)
  return x >= cx and x <= cx + cellWidth and
  y >= cy and y <= cy + cellHeight
end

function love.move(cell)
  grid[cell] = turn
  love.checkboard()
  if turn == 1 then turn = 2 else turn = 1 end
end

function love.checkboard()
  love.checkwin(1, 2, 3)
  love.checkwin(4, 5, 6)
  love.checkwin(7, 8, 9)
  love.checkwin(1, 4, 7)
  love.checkwin(2, 5, 8)
  love.checkwin(3, 6, 9)
  love.checkwin(1, 5, 9)
  love.checkwin(3, 5, 7)
end

function love.checkwin(a, b, c)
  if grid[a] == turn and grid[b] == turn and grid[c] == turn then
  	reset = true
  	line = {a, c}
  end
end

function love.keypressed(key)
  if key == "r" then
    for k, v in pairs(grid) do grid[k] = 0 end
    turn = 1
    reset = false
  end
end
