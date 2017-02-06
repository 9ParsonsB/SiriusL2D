--Single cell on a grid
local Cell = class("Cell")

Cell.G, Cell.H, Cell.F = 0, 0, 0

function Cell:Create(row, column, walkable)
  self.Row, self.Column = row or 0, column or 0
  self.Walkable = walkable or true
end

function Cell:reset()
  self.G, self.H, self.F = 0, 0, 0
  self.Parent = nil
end

function Cell:calculateCost(current, finish)
  --G cost is the current G cost + the movement cost(10 for up/down and 14 for diagonal)
  local G = 10
  if self.Row ~= current.Row and self.Column ~= current.Column then G = 14 end
  self.G = current.G + G 

  --H cost(Distance to the finish cell)
  self.H = (math.abs(finish.Row - self.Row) + math.abs(finish.Column - self.Column)) * 10

  --F cost(G + H)
  self.F = self.G + self.H
end

function Cell:Draw(grid)
  --Draw unwalkable cells
  if not self.Walkable then
    local colour = {0, 0, 0}
    local x,y = grid:GetCellPosition(self)
    Renderer.Box(x, y, grid.CellWidth, grid.CellHeight, colour)
  end

  --Debug path values
  if grid.Debug and self.F ~= 0 then
    local x,y = grid:GetCellPosition(self)
    love.graphics.print(self.G, x, y)
  end
end

--Grid that stores 2d table of cells
--Uses A* to generate a path between two points
local Grid = class("Grid")

--Width and height of a single cell
Grid.CellWidth = 30
Grid.CellHeight = 30

Grid.Debug = false
Grid.ShowLines = false

function Grid:Create(x, y, row, column)
  self.X, self.Y = x, y
  self.RowCount, self.ColumnCount = row, column
  self.Width, self.Height = self.CellWidth * self.RowCount, self.CellHeight * self.ColumnCount
  self:Clear()
end

function Grid:Draw()
  --Draw grid lines
  if self.ShowLines then
    for i = 0, self.RowCount do Renderer.Line(self.X + self.CellWidth * i, self.Y, self.X + self.CellWidth * i, self.Y + self.Height) end
    for i = 0, self.ColumnCount do Renderer.Line(self.X , self.Y + self.CellHeight * i, self.X + self.Width, self.Y + self.CellHeight * i) end
  end

  --Draw cells
  for i,Row in pairs(self.Cells) do
    for j, Cell in pairs(Row) do Cell:Draw(self) end
  end
end

--Setup cells table with default cells
function Grid:Clear()
  self.Cells = {}
  for i=0, self.RowCount - 1 do self.Cells[i] = {} 
    for j=0, self.ColumnCount - 1 do self.Cells[i][j] = Cell(i, j) end
  end
end

function Grid:resetCosts()
  for i,Row in pairs(self.Cells) do
    for j, Cell in pairs(Row) do Cell:reset() end
  end
end

--toggles the walkability of a cell
function Grid:toggle(x, y)
  local cell = self:getCell(self:getCellLocation(x, y))
  cell.Walkable = not cell.Walkable
end

function Grid:place(x, y)
  local cell = self:getCell(self:getCellLocation(x, y))
  cell.Walkable = false
end

function Grid:remove(x, y)
  local cell = self:getCell(self:getCellLocation(x, y))
  cell.Walkable = true
end

--Convert x, y to row, column
function Grid:getCellLocation(x, y)
  local distX, distY = x - self.X, y - self.Y
  return math.floor(distX / self.CellWidth), math.floor(distY / self.CellHeight)
end

--Convert row, column to x, y
function Grid:getCellPosition(cell)
  return self.X + (self.CellWidth * cell.Row), self.Y + (self.CellHeight * cell.Column)
end

--Get center of the cell
function Grid:getCellCenter(cell)
  local x, y = self:GetCellPosition(cell)
  x = x + self.CellWidth / 2
  y = y + self.CellHeight / 2
  return x, y
end

--Get cell at row and column
function Grid:getCell(row, column)
  --Clamp row and column to grid
  row = math.min(math.max(0, row), self.RowCount - 1)
  column = math.min(math.max(0, column), self.ColumnCount - 1)
  return self.Cells[row][column]
end

--Find cells around the cell passed in
function Grid:getAdacentCells(cell)
  local cells = {}

  table.insert(cells, self:GetCell(cell.Row - 1, cell.Column - 1))
  table.insert(cells, self:GetCell(cell.Row, cell.Column - 1))
  table.insert(cells, self:GetCell(cell.Row + 1, cell.Column - 1))
  table.insert(cells, self:GetCell(cell.Row - 1, cell.Column))
  table.insert(cells, self:GetCell(cell.Row + 1, cell.Column))
  table.insert(cells, self:GetCell(cell.Row - 1, cell.Column + 1))
  table.insert(cells, self:GetCell(cell.Row, cell.Column + 1))
  table.insert(cells, self:GetCell(cell.Row + 1, cell.Column + 1))

  return cells
end

--Return cell with the lowest F cost from the set
function Grid:getLowestFCell(set)
  local lowest = nil
  for k,v in pairs(set) do
    if not lowest then lowest = k end
    if k.F < lowest.F then lowest = k end
  end
  return lowest
end

--Calculate a path between 2 points on the grid
function Grid:pathFind(x1, y1, x2, y2)
  self:resetCosts()

  --Start and finish cells
  local start = self:getCell(self:getCellLocation(x1, y1))
  local finish = self:getCell(self:getCellLocation(x2, y2))

  --Return if cell cannot be pathed to
  if not start.Walkable or not finish.Walkable then return {} end

  --Open/closed lists
  local open, closed = {}, {}
  open[start] = true

  repeat
    --Move cell with lowest f cost to closed list
    local current = self:getLowestFCell(open)
    open[current] = nil
    closed[current] = true

    --For each of the 8 cells adjacent
    local adjacentCells = self:getAdacentCells(current)
    for k,v in pairs(adjacentCells) do

      --If it is walkable and it is not on the closed list
      if v.Walkable and not closed[v] then
      
        --If it is not on the open list then add it. Make the current cell the parent of this cell and calculate the costs
        if not open[v] then
          open[v] = true
          v.Parent = current
          v:calculateCost(current, finish)
        else

          --If it is already on the open list the check if the path is better using the G cost.
          local Distance = current.G + 10
          if current.Row ~= v.Row and current.Column ~= v.Column then Distance = current.G + 14 end

          --print(Distance)
          if Distance < v.G then
            v.Parent = current
            v:calculateCost(current, finish)
          end
        end
      end
    end
  until closed[finish]
    
  --Get path
  local Path = self:getPath(finish)

  --local distX, distY = Path[1].X - x1, Path[1].Y - y1
  --for k,v in pairs(Path) do v.X, v.Y = v.X - distX, v.Y - distY end

  --Path[1].X, Path[1].Y = x1, y1
  --Path[#Path].X, Path[#Path].Y = x2, y2

  return Path
end

--Generates a path using the parent of the cell
function Grid:getPath(cell)
  --Get path from finish to start
  local t = {}
  repeat
    table.insert(t, cell)
    cell = cell.Parent
  until not cell

  --Reverse path
  local t1 = {}
  for i = #t, 1, -1 do table.insert(t1, t[i]) end

  --Generate x,y coords for the path
  local path = {}
  for k,v in pairs(t1) do
    local x, y = self:getCellCenter(v)
    table.insert(path, {X = x, Y = y})
  end

  return path
end
return Grid