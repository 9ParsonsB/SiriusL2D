local env = setmetatable({}, {__index=_G})
local loading = false
local FileInfo = {}

Script = {}

function Script.Load(filePath)
  loading = true

  local chunk = love.filesystem.load(filePath .. ".lua")
  setfenv(chunk, env)
  chunk()

  --Track file
  FileInfo[filePath] = love.filesystem.getLastModified(filePath .. ".lua")

  loading = false
end

function Script.Update(dt)
  for k, v in pairs(FileInfo) do
    if v ~= love.filesystem.getLastModified(k .. ".lua") then Script.Load(k) end
  end
end

local Classes = {}
local function Instance(class, ...)
  local self = setmetatable({}, {__index=class})
  if type(self.Create) == "function" then self:Create(...) end
  return self
end

function Class(name, parent)
  --Return existing class
  if Classes[name] then
  	if loading then env[name] = Classes[name] end
    return Classes[name]
  end

  --Create class
  local class = setmetatable({Name=name, Parent=parent or {}}, {__call=Instance, __index=parent})
  Classes[name] = class 

  --Add class to script enviroment
  if loading then env[name] = class end

  return class
end