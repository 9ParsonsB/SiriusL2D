--Single cell on a grid
local Cell = Class("Cell")

Cell.G, Cell.H, Cell.F = 0, 0, 0

function Cell:Create(row, column, walkable)
  self.Row, self.Column = row or 0, column or 0
  self.Walkable = walkable or true
end

function Cell:CalculateCost(target, finish)
  --If cell is diagonal to the target the the G cost is 14. Otherwise it is 10.
  self.G = 10
  if self.Row ~= target.Row and self.Column ~= target.Column then self.G = 14 end

  --H cost(Heuristic/guess, the distance to the finish cell)
  self.H = ((finish.Row - self.Row) + (finish.Column - self.Column)) * self.G

  --F cost which is used to determine if cell should be pathed to. Result of both G and H.
  self.F = self.G + self.H
end

--Grid that stores 2d table of cells
--Uses A* to generate a path between two points
Grid = Class("Grid")

--Width and height of a single cell
Grid.CellWidth = 30
Grid.CellHeight = 30

function Grid:Create(x, y, row, column)
  self.X, self.Y = x, y
  self.RowCount, self.ColumnCount = row, column
  self.Width, self.Height = self.CellWidth * self.RowCount, self.CellHeight * self.ColumnCount
  self:Clear()
end

function Grid:Draw()
  --Draw columns
  for i = 0, self.ColumnCount do
    love.graphics.line(self.X + self.CellWidth * i, self.Y, self.X + self.CellWidth * i, self.Y + self.Height)
  end

  --Draw rows
  for i = 0, self.RowCount do
    love.graphics.line(self.X , self.Y + self.CellHeight * i, self.X + self.Width, self.Y + self.CellHeight * i)
  end

  --Draw cells
  for k,v in pairs(self.Cells) do
    for k2, v2 in pairs(v) do
      if not v2.Walkable then
        love.graphics.rectangle("fill", self.X + v2.Row * self.CellHeight, self.Y + v2.Column * self.CellHeight, self.CellWidth, self.CellHeight)
      end
    end
  end
end

--Setup cells table with default cells
function Grid:Clear()
  self.Cells = {}
  for i = 0, self.ColumnCount - 1 do self.Cells[i] = {} 
    for j = 0, self.RowCount - 1 do self.Cells[i][j] = Cell(i, j) end
  end
end

--Convert x, y to row, column
function Grid:GetCellLocation(x, y)
  local distX, distY = x - self.X, y - self.Y
  return math.floor(distX / self.CellWidth), math.floor(distY / self.CellHeight)
end

--Convert row, column to x, y
function Grid:GetCellPosition(cell)
  return self.X + (self.CellWidth * cell.Row), self.Y + (self.CellHeight * cell.Column)
end

--Get center of the cell
function Grid:GetCellCenter(cell)
  local x, y = self:GetCellPosition(cell)
  x = x + self.CellWidth / 2
  y = y + self.CellHeight / 2
  return x, y
end

--Get cell at row and column
function Grid:GetCell(row, column)
  --Clamp row and column to grid
  row = math.min(math.max(0, row), self.RowCount - 1)
  column = math.min(math.max(0, column), self.ColumnCount - 1)
  return self.Cells[row][column]
end

--Find cells around the cell passed in
function Grid:GetAdacentCells(cell)
  local cells = {}

  cells.TopLeft = self:GetCell(cell.Row - 1, cell.Column - 1)
  cells.Top = self:GetCell(cell.Row, cell.Column - 1)
  cells.TopRight = self:GetCell(cell.Row + 1, cell.Column - 1)
  cells.Left = self:GetCell(cell.Row - 1, cell.Column)
  cells.Right = self:GetCell(cell.Row + 1, cell.Column)
  cells.BottomLeft = self:GetCell(cell.Row - 1, cell.Column - 1)
  cells.Bottom = self:GetCell(cell.Row, cell.Column + 1)
  cells.BottomRight = self:GetCell(cell.Row + 1, cell.Column + 1)

  return cells
end

--Return cell with the lowest F cost from the set
function Grid:GetLowestFCell(set)
  local lowest = nil
  for k,v in pairs(set) do
    if not lowest then lowest = k end
    if k.F < lowest.F then lowest = k end
  end
  return lowest
end

--Calculate a path between 2 points on the grid
function Grid:PathFind(x1, y1, x2, y2)
  --Start and finish cells
  local start = self:GetCell(self:GetCellLocation(x1, y1))
  local finish = self:GetCell(self:GetCellLocation(x2, y2))

  --Cannot path if start or finish does not exist
  if not start or not finish then return end

  --Add start cell to the open list
  local open, closed = {}, {}
  open[start] = true

  --Start searching for the path
  repeat   
    --Look for the lowest F cost square on the open list
    --and switch it to the closed list
    local current = self:GetLowestFCell(open)
    open[current] = nil
    closed[current] = true

    --For each of the 8 cells adjacent
    local adjacentCells = self:GetAdacentCells(current)
    for k,v in pairs(adjacentCells) do

      --If it is walkable and it is not on the closed list
      if v.Walkable and not closed[v] then
 
        --If it is not on the open list then add it. Make the current cell the parent of this cell and calculate the costs
        if not open[v] then
          open[v] = true
          v.Parent = current
          v:CalculateCost(current, finish)
        else
          --If it is already on the open list the check if the path is better. Check if the G cost of this cell is lower than the current G cost.
          --If it is then change the better cells parent to the current and recalculate the G and F scores of it.
          if v.G < current.G then
            v.Parent = current
            v:CalculateCost(current, finish)
          end
        end
      end
    end
  --Keep pathing until the finish cell is found
  until closed[finish]

  --Get the path from the start to finish
  local path = self:GetPath(finish)
  path[1].X, path[1].Y = x1, y1
  path[#path].X, path[#path].Y = x2, y2 

  return path
end

--Generates a path using the parent of the cell
function Grid:GetPath(finish)
  local t, cell = {}, finish

  --Get path from finish to start
  repeat
    table.insert(t, cell)
    cell = cell.Parent
  until not cell

  --Convert path to start to finish
  local t1 = {}
  for i = #t, 1, -1 do table.insert(t1, t[i]) end

  --Generate x,y coords for the path
  local path = {}
  for k,v in pairs(t1) do
    local x, y = self:GetCellCenter(v)
    table.insert(path, {X = x, Y = y})
  end

  return path
end