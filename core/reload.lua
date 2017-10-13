package.watched = {}

function ge.load(path, reload)
  if reload then  
    local modtime, errormsg = love.filesystem.getLastModified(path .. ".lua")
    
    if errormsg then 
      print(errormsg)
      return
    end
    
    package.watched[path] = modtime
  end
  return require(path)
end

local function unload(path)
  package.loaded[path] = nil
  package.watched[path] = nil
end

function ge.reload(dt)
  local current
  for k,v in pairs(package.watched) do
    current = love.filesystem.getLastModified(k .. ".lua")
    if current ~= v then
      unload(k)
      
      ge.load(k, true)
      
      -- if error keep old version of lua file
      -- safe crash
      --[[local success, res = pcall(require, k)
      if success then
        local modtime, errormsg = love.filesystem.getLastModified(k)
        package.watched[k] = modtime
      end--]]
    end
  end
end