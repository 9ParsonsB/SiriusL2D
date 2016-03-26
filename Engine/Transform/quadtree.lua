QuadTree = Class("Quadtree")

QuadTree.F = 0
QuadTree.G = 10
QuadTree.H = 0

function QuadTree:Create(x, y, width, height)
  self.Level = level
  self.Objects = {}

  self.X, self.Y = x, y
  self.Width, self.Height = width, height
  self.CenterX, self.CenterY = self.X + self.Width / 2, self.Y + self.Height / 2
end

function QuadTree:Draw()
  love.graphics.rectangle("line", self.X, self.Y, self.Width, self.Height)
  for k,v in pairs(self.Nodes) do
    v:Draw()
  end

  for k,v in pairs(self.Objects) do
    love.graphics.rectangle("line", v.X, v.Y, v.Width, v.Height)
  end
end

function QuadTree:Clear()
  self.Objects = {}
  for k,v in pairs(self.Nodes) do v:Clear() end
  self.Nodes = {}
end

function QuadTree:Split()
  local subWidth = self.Width / 2
  local subHeight = self.Height / 2

  self.Nodes[0] = QuadTree(self.X, self.Y, subWidth, subHeight)
  self.Nodes[1] = QuadTree(self.X + subWidth, self.Y, subWidth, subHeight)
  self.Nodes[2] = QuadTree(self.X, self.Y + subHeight, subWidth, subHeight)
  self.Nodes[3] = QuadTree(self.X + subWidth, self.Y + subHeight, subWidth, subHeight)

  --Set parent for nodes
  for k,v in pairs(self.Nodes) do v.Parent = self end
end

function QuadTree:GetIndex(object)
  local index = -1
  local verticalMidpoint = self.X + (self.Width / 2)
  local horizontalMidpoint = self.Y + (self.Height / 2)

  --Store if area is in top or bottom quadrant
  local topQuadrant = object.Y < horizontalMidpoint and object.Y + object.Height < horizontalMidpoint
  local bottomQuadrant = object.Y > horizontalMidpoint

  --Object can completely fit within the left quadrants
  if object.X < verticalMidpoint and object.Y + object.Width < verticalMidpoint then
  	if topQuadrant then 
  	  index = 0 
    elseif bottomQuadrant then
      index = 2
    end

  --Object can completely fit within the right quadrants
  elseif object.X > verticalMidpoint then
  	if topQuadrant then
  	  index = 1
  	elseif bottomQuadrant then
  	  index = 3
    end
  end

  return index
end

function QuadTree:Insert(x, y, width, height)
  local object = {X=x, Y=y, Width=width, Height=height}

  if self.Nodes[0] then
  	local index = self:GetIndex(object)
  	if index ~= -1 then
  	  self.Nodes[index]:Insert(x, y, width, height)
  	  return
  	end
  end

  --Store object
  table.insert(self.Objects, object)

  --if #self.Objects >= self.MAX_OBJECTS and self.Level < self.MAX_LEVELS then
  if self.Width > object.Width + 2 and self.Height > object.Height + 2 then
  	if not self.Nodes[0] then
  	  self:Split()
    end

    local i = 1
    while i <= #self.Objects do
      local object = self.Objects[i]

      local index = self:GetIndex(object)
      if index ~= -1 then
      	self.Nodes[index]:Insert(object.X, object.Y, object.Width, object.Height)
        table.remove(self.Objects, i)
      else
      	i = i + 1
        for k,v in pairs(self.Nodes) do
          v:Insert(object.X, object.Y, object.Width, object.Height) 
        end
      end
    end
  end
end