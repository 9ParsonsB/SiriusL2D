local Button = require "Ui/button"
local Label = require "Ui/label"
local Slider = require "Ui/slider"
local Theme = require "Ui/theme"

local Menus = setmetatable({}, {__mode="v"})
local Menu = Class("Menu")

Menu.Active = true

function Menu:Create(name)
  self.Theme = Theme()
  self.Widgets = {}

  --Store menu
  if name then Menus[name] = self end
  table.insert(Ui.Menus, self)
end

function Menu:Enable(name)
  if name then Menus[name].Active = true
  else self.Active = true end
end

function Menu:Disable(name)
  if name then Menus[name].Active = false
  else self.Active = false end
end

function Menu:Toggle(name)
  if name then Menus[name].Active = not Menus[name].Active
  else self.Active = not self.Active end
end

--Callbacks
function Menu:Update(dt) end
function Menu:KeyPressed(key) end

function Menu:Draw()
  if not self.Active then return end
  for k,v in pairs(self.Widgets) do v:Draw(self.Theme) end
  self.Widgets = {}
end

function Menu:Button(text, x, y, w, h)
  local button = Button(text, x, y, w, h)
  table.insert(self.Widgets, button)
  return button
end

function Menu:Label(text, x, y, w, h)
  local label = Label(text, x, y, w, h)
  table.insert(self.Widgets, label)
  return label
end

function Menu:Slider(info, x, y, w, h)
  local slider = Slider(info, x, y, w, h)
  table.insert(self.Widgets, slider)
  return slider
end
return Menu