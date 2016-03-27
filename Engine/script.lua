Scripts = {}
Objects = {}

local Instances = {}
local Indexes = {}
local TypeInstances = {}

Script = {
  LiveEdit = true,
  FileInfo = {}
}

function Script.Execute(object, name, ...)
  for k, v in pairs(object.Scripts) do
    if type(Scripts[v][name]) == "function" then
      Scripts[v][name](object, ...)
    end
  end
end

function Script.ExecuteAll(name, ...)
  for k, v in pairs(Instances) do Script.Execute(v, name, ...) end
end

function Script.Update(dt)
  Script.ExecuteAll("Update", dt)

  --Live script editing
  if Script.LiveEdit then Script.Reload() end
end

function Script.Draw()
  Script.ExecuteAll("Draw")
  Script.ExecuteAll("DrawUi")
end

function Script.KeyPressed(key)
  Script.ExecuteAll("KeyPressed", key)
end

function Script.KeyReleased(key)
  Script.ExecuteAll("KeyReleased", key)
end

function Script.MousePressed(x, y, button, isTouch)
  Script.ExecuteAll("MousePressed", x, y, button, isTouch)
end

function Script.MouseReleased(x, y, button, isTouch)
  Script.ExecuteAll("MouseReleased", x, y, button)
end

function Script.MouseMoved(x, y, dx, dy)
  Script.ExecuteAll("MouseMoved", x, y, dx, dy)
end

--Reloads modified scripts
function Script.Reload()
  for k,v in pairs(Scripts) do
    --Get file info
    local info = Script.FileInfo[v]
    local modTime = love.filesystem.getLastModified(info.filePath .. ".lua")
    
    --If the file has been modified then reload it
    if info.modTime ~= modTime then 
      info.modTime = modTime
      Scripts[k] = LoadScript(info.filePath) 
    end
  end
end

function LoadScript(filePath)
  --Load script
  local env = setmetatable({}, {__index=_G})
  local chunk = love.filesystem.load(filePath .. ".lua")

  --Execute script
  setfenv(chunk, env)
  chunk()

  --Store script info for live editing
  Script.FileInfo[env] = {
    filePath = filePath,
    modTime = love.filesystem.getLastModified(filePath .. ".lua"),
  }

  return env
end

function LoadObject(filePath)
  --Load object script
  local env = setmetatable({Scripts = {}}, {__index=_G}) 
  local chunk = love.filesystem.load(filePath .. ".lua")

  --Execute object script
  setfenv(chunk, env)
  chunk()

  return env
end

function GetObjects(name)
  return TypeInstances[name]
end

function Instance(name, x, y)
  local self = {Name = name, X = x or 0, Y = y or 0}
  for k,v in pairs(Objects[name]) do self[k] = v end

  --Store object
  table.insert(Instances, self)
  Indexes[self] = #Instances

  --Store object by type
  TypeInstances[name] = TypeInstances[name] or setmetatable({}, {__mode="v"})
  table.insert(TypeInstances[name], self)

  --Create callback for scripts
  Script.Execute(self, "Create")

  return self
end

function Destroy(self)
  local index = Indexes[self]
  if index then
    Instances[index] = Instances[#Instances]
    Indexes[self] = nil
    table.remove(Instances)
  end
end