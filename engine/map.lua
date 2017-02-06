map = {}

math.randomseed(os.time())

map.tile_width = 50
map.tile_height = 50
map.hcells = 20
map.vcells = 20
map.nodes = {}

-- fill map
for i = 1, map.hcells do 
for j = 1, map.vcells do 
  map.nodes[i .. j] = {x=i, y=j, v=0}
end 
end

function map.draw(lines)
  for i = 1, map.hcells do
    for j = 1, map.vcells do 
  	  map.drawTile(map.nodes[i .. j].v, (i - 1) * map.tile_width, (j - 1) * map.tile_height, map.tile_width, map.tile_height)
  	end
  end

  -- optional grid lines
  if not lines then return end
  love.graphics.setColor(255, 255, 255)
  for i = 0, map.hcells do love.graphics.line(i * map.tile_width, 0, i * map.tile_width, map.tile_height * map.vcells) end
  for i = 0, map.vcells do love.graphics.line(0, i * map.tile_height, map.tile_width * map.hcells, i * map.tile_height) end
end

function map.drawTile(v, x, y, w, h)
  if v == 0 then
  	love.graphics.setColor(128, 128, 128)
    love.graphics.rectangle("fill", x, y, w, h)
  elseif v == 1 then
  	love.graphics.setColor(0, 102, 234)
    love.graphics.rectangle("fill", x, y, w, h)
  elseif v == 2 then
  	love.graphics.setColor(204, 102, 0)
    love.graphics.rectangle("fill", x, y, w, h)
  end
end

-- https://github.com/lattejed/a-star-lua/blob/master/a-star.lua
-- testing

local INF = 1/0
local cachedPaths = nil

local function dist( x1, y1, x2, y2 )
  return math.sqrt(math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2))
end

local function dist_between(nodeA, nodeB)
  return dist(nodeA.x, nodeA.y, nodeB.x, nodeB.y)
end

local function heuristic_cost_estimate(nodeA, nodeB)
  return dist(nodeA.x, nodeA.y, nodeB.x, nodeB.y)
end

local function is_valid_node(node, neighbor)
  return true
end

local function lowest_f_score(set, f_score)
  local lowest, bestNode = INF, nil
  for _, node in ipairs(set) do
    local score = f_score[node]
    if score < lowest then
      lowest, bestNode = score, node
    end
  end
  return bestNode
end

local function neighbor_nodes(theNode, nodes)
  local neighbors = {}
  for _, node in ipairs (nodes) do
    if theNode ~= node and is_valid_node(theNode, node) then
      table.insert(neighbors, node)
    end
  end
  return neighbors
end

local function not_in(set, theNode)
  for _, node in ipairs(set) do
    if node == theNode then return false end
  end
  return true
end

local function remove_node(set, theNode)
  for i, node in ipairs(set) do
    if node == theNode then 
      set[i] = set[#set]
      set[#set] = nil
      break
    end
  end 
end

local function unwind_path(flat_path, map, current_node)
  if map[current_node] then
    table.insert(flat_path, 1, map[current_node]) 
    return unwind_path(flat_path, map, map [current_node])
  else
    return flat_path
  end
end

local function astar(start, goal, nodes, valid_node_func)
 
  local closedset = {}
  local openset = { start }
  local came_from = {}

  if valid_node_func then is_valid_node = valid_node_func end

  local g_score, f_score = {}, {}
  g_score[start] = 0
  f_score[start] = g_score[start] + heuristic_cost_estimate(start, goal)

  while #openset > 0 do
  
    local current = lowest_f_score(openset, f_score)
    if current == goal then
      local path = unwind_path({}, came_from, goal)
      table.insert(path, goal)
      return path
    end

    remove_node(openset, current)    
    table.insert(closedset, current)
    
    local neighbors = neighbor_nodes(current, nodes)
    for _, neighbor in ipairs(neighbors) do 
      if not_in(closedset, neighbor) then
      
        local tentative_g_score = g_score[current] + dist_between(current, neighbor)
        
        if not_in(openset, neighbor) or tentative_g_score < g_score[neighbor] then 
          came_from[neighbor] = current
          g_score[neighbor] = tentative_g_score
          f_score[neighbor] = g_score[neighbor] + heuristic_cost_estimate(neighbor, goal)
          if not_in(openset, neighbor) then
            table.insert(openset, neighbor)
          end
        end
      end
    end
  end
  return nil
end

local function clear_cached_paths()
  cachedPaths = nil
end

local function distance(x1, y1, x2, y2)
  return dist (x1, y1, x2, y2)
end

local function path(start, goal, nodes, ignore_cache, valid_node_func)
  if not cachedPaths then cachedPaths = {} end
  if not cachedPaths[start] then
    cachedPaths[start] = {}
  elseif cachedPaths[start][goal] and not ignore_cache then
    return cachedPaths[start][goal]
  end
  return astar(start, goal, nodes, valid_node_func)
end

--this function determines which neighbors are valid (e.g, within range)
local valid_node_func = function (node, neighbor) 
    local MAX_DIST = 1

    -- helper function in the a-star module, returns distance between points
    if math.abs(node.x - neighbor.x) <= MAX_DIST and math.abs(node.y - neighbor.y) <= MAX_DIST and neighbor.v == 0 then
        return true
    end
    return false
end

function map.path(x1, y1, x2, y2)
  local start = map.nodes[math.floor(x1 / map.tile_width) + 1 .. math.floor(y1 / map.tile_height) + 1]
  local goal = map.nodes[math.floor(x2 / map.tile_width) + 1 .. math.floor(y2 / map.tile_height) + 1]
  
  print(goal.x .. " " .. goal.y)

  local path = path(start, goal, map.nodes, false, valid_node_func)
  if path then
    for k, v in pairs(path) do
      print(v.x .. " " .. v.y)
    end
  end
  return path
end
