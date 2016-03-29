Scripts = {}
local FileInfo = {}

local Objects = {}
local Indexes = {}

Script = {
  Dir = "Scripts/",
  LiveEdit = true,
}

function Script.Reload()
  for k,v in pairs(Scripts) do
    local modTime = love.filesystem.getLastModified(Script.Dir .. k .. ".lua")
    if modTime ~= FileInfo[k].ModTime then 
      FileInfo[k].ModTime = modTime
      Script(k, FileInfo[k].FilePath) 
    end
  end
end

function Script:Load(name, filePath)
  local env = Scripts[name] or setmetatable({}, {__index=_G})
  local chunk = love.filesystem.load(Script.Dir .. filePath .. ".lua")
  setfenv(chunk, env)
  chunk()

  --Store script
  Scripts[name] = env 
  FileInfo[name] = {ModTime = love.filesystem.getLastModified(Script.Dir .. filePath .. ".lua"), FilePath = filePath}

  return env
end
setmetatable(Script, {__call=Script.Load})

function Object(name, parent)
  local object = setmetatable({Name = name}, {__index=Scripts[name]})
  Objects[name] = object

  --Inherit from parent
  if parent and Scripts[parent] then
    object.Parent = Scripts[parent]
    setmetatable(Scripts[name], {__index=Scripts[parent]})
  end
end

function Instance(name, x, y)
  local self = setmetatable({X = x or 0, Y = y or 0}, {__index=Objects[name]})
  table.insert(Scene.Objects, self)
  Indexes[self] = #Scene.Objects

  --Create constructor chain
  local chain, object = {}, self
  while object do
    table.insert(chain, object)
    object = object.Parent
  end

  --Run constructors
  for i = #chain, 1, -1 do
    if type(chain[i].Create) == "function" then chain[i].Create(self) end
  end
  return self
end

function Destroy(self)
  local index = Indexes[self]
  if index then
    Indexes[self] = nil
    Scene.Objects[index] = nil

    local body = Physics.Colliders[self]
    if body then body:destroy() end
  end
end