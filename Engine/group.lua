local Camera = require "Engine/camera"

local Group = {}
local Groups = {}

function Group.New(name)
  local group = setmetatable({Objects = {}, Count = 0, Visible = true}, {__index=Group})
  Groups[name] = group
  return group
end

function Group:Add(object)
  self.Objects[self.Count] = object
  self.Count = self.Count + 1
end

--Create camera for group
function Group.SetCamera(name, ...)
  local group = Group.Get(name)
  group.Camera = Camera.New(...)
end

--Get camera from group
function Group.GetCamera(name)
  local group = Group.Get(name)
  return group.Camera or Camera.New()
end

--Get group
--Creates a new one if none exists
function Group.Get(name)
  return Groups[name] or Group.New(name)
end

function Group:Update(dt)
  for k,v in pairs(self.Objects) do
    if type(v.Update) == "function" then v.Update(dt) end
  end
end

function Group:Draw()
  --Only draw if visible
  if not self.Visible then return end

  --Apply camera settings
  local camera = self.Camera
  if camera then camera:Set() end
    
  for k,v in pairs(self.Objects) do
    if type(v.Draw) == "function" then v.Draw(dt) end
  end

  --Clear camera settings
  if camera then camera:Unset() end
end

function Group:KeyPressed(key)
  for k,v in pairs(self.Objects) do
    if type(v.KeyPressed) == "function" then v.KeyPressed(key) end
  end
end

function Group:KeyReleased(key)
  for k,v in pairs(self.Objects) do
    if type(v.KeyReleased) == "function" then v.KeyReleased(key) end
  end
end
return Group