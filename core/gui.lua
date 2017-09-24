gui = {}

local style = 
{
	BACK = {45, 45, 45, 200},
	TEXT = {255, 255, 255, 255},
	IDLE = {64, 64, 64, 255},
	HOVER = {0, 102, 204, 255},
	PRESSED = {0, 102, 204, 255},
	SLIDER = {38, 38, 38, 255},
	SLIDER_CURSOR_IDLE = {100, 100, 100, 255},
	SLIDER_CURSOR_HOVER = {120, 120, 120, 255},
	SLIDER_CURSOR_PRESSED = {150, 150, 150, 255}
}

local commands = {}
local row = {x=0,y=0,w=0,h=0}
local box = {x=0,y=0,w=0,h=0}
local widths = {}
local space = 10
local index = 1
local cols = 1
local padding = 10 -- = {x=0,y=0,w=0,h=0}
local state = {menu=false, settings=false, debug=true}
local change = {}

-- clear commands, update states
function gui.update(dt)
  commands = {}
  for k,v in pairs(change) do state[k] = v end
  change = {}
  gui.menu()

  if ge.pressed("escape") then state.menu = not state.menu end
	if ge.pressed("escape") and state.settings then gui.switch("settings", "menu") end
	if ge.pressed("f3") then state.debug = not state.debug end
end

-- run commands(rectangle/circle/text)
function gui.draw()
	love.graphics.push("all")
	for k,v in pairs(commands) do v() end
	commands = {}
	love.graphics.pop()
end

function gui.switch(a, b)
	change[a] = false
	change[b] = true
end

-- rectangle draw command(gui.draw)
function gui.rectangle(mode, x, y, w, h, rx, ry, colour)
	table.insert(commands, function ()
		love.graphics.setColor(colour)
		love.graphics.rectangle(mode, x, y, w, h, rx, ry)
		-- love.graphics.rectangle(mode, data.x, data.y, data.w, data.h)
	end)
end

-- circle draw command(gui.draw)
function gui.circle(mode, x, y, radius, colour)
	table.insert(commands, function ()
		love.graphics.setColor(colour)
		love.graphics.circle(mode, x, y, radius)
	end)
end

-- text draw command(gui.draw)
function gui.printf(text, x, y, w, align)
	table.insert(commands, function ()
		love.graphics.setColor(style.TEXT)
		love.graphics.printf(text, x, y, w, align)
	end)
end

-- control layout(% of screen size)
function gui.begin(title, x, y, w, h, mode)
	local width, height = love.graphics.getDimensions()
  x = math.floor((x / 100) * width)
  y = math.floor((y / 100) * height)
  w = math.floor((w / 100) * width)
  h = math.floor((h / 100) * height)

  -- layout
  row = {x=x + padding, y=y + padding, w=w - padding, h=h - padding}
	box = {x=row.x, y=row.y, w=row.w, h=row.h}
	
  -- background
	if state[title] and mode == "fill" then gui.rectangle("fill", x, y, w + padding, h + padding, 0, 0, style.BACK) end
	return state[title]
end

-- start a row for the control layout
function gui.row(mode, height, c)
	box = {x=row.x, y=row.y,w=row.w}
	box.h = math.floor((height / 100) * love.graphics.getHeight())
	index = 1

	-- full width available
	cols = c
	if type(c) == "table" then cols = #c end
	local gap = space * (cols - 1)
	local tw = (row.w - gap)

	-- store row widths
	widths = {}
	if type(c) == "number" then
		for i=1, c do widths[i] = tw / cols end
	else
		for k,v in pairs(c) do widths[k] = math.floor(v * tw) end
	end
	box.w = widths[index]
end

-- move to next control
function gui.advance()
	if index == cols then
		row.y = row.y + box.h + space
		box.x, box.y = row.x, row.y
		index = 1
	else
		box.x = box.x + box.w + space
		index = index + 1
	end
	box.w = widths[index]
end

-- mouse over control
function gui.hover(x, y, w, h)
	local mx, my = love.mouse.getPosition()
	if h then return ge.intersectBox(mx, my, x, y, w, h)
	else return ge.intersectCircle(mx, my, x, y, w) end
end

-- state of control(idle, hover, pressed)
function gui.getState(a, b, c, d)
  local hover = gui.hover(a, b, c, d)
  local state = "IDLE"
  if hover then state = "HOVER" end
  if ge.pressed(1) and hover then state = "PRESSED" end
  return state
end

-- text display control
function gui.label(text, align)
	gui.printf(text, box.x, box.y, box.w, align or "left")
	gui.advance()
end

-- standard button that is presses once
function gui.button(text)
  local state = gui.getState(box.x, box.y, box.w, box.h)
  gui.rectangle("fill", box.x, box.y, box.w, box.h, 5, 5, style[state])
  gui.printf(text, box.x, box.y, box.w, "center")
  gui.advance()
  return state == "PRESSED"
end

-- button that toggles state when pressed
function gui.toggle(text, value)
	local state = gui.getState(box.x, box.y, box.w, box.h)
	if state == "PRESSED" then value = not value end

  gui.rectangle("fill", box.x, box.y, box.w, box.h, 5, 5, style[state])
  gui.printf(text, box.x, box.y, box.w, "center")
  gui.advance()
	return value
end

-- edit value using textbox
function gui.edit(value)

end

-- dropdown box using table
function gui.combo(combo)
	local state = gui.getState(box.x, box.y, box.w, box.h)
	gui.label(combo.items[combo.value])
	for k,v in pairs(combo.items) do 
		if gui.button(v) then print("combo " .. v) end 
	end
	return false
end

-- horizontal slider, range(min, max)
function gui.slider(min, value, max)

end

-- default keybinding	
function gui.keymap(count)
	-- local ratio = {0.2, 0.4, 0.4}
	-- gui.row("dynamic", 3, ratio)
	-- gui.label("Action", "center")
	-- gui.label("Key 1", "center")
	-- gui.label("Key 2", "center")

	-- for k,v in pairs(ge.binds) do
	-- 	gui.row("dynamic", 3, ratio)
	-- 	gui.label(v[1] or "", "center")
	-- 	if gui.toggle(v[2] or "", ge.info.binds == v and ge.info.index == 2) then ge.remap(v, 2) end
	-- 	if gui.toggle(v[3] or "", ge.info.binds == v and ge.info.index == 3) then ge.remap(v, 3) end
	-- end
end

-- default menu system(menu, settings, debug)
local combo = {value=1, items={"1", "2", "3"}}
local value = 50
function gui.menu()
  -- menu(center, escape to toggle)
  if gui.begin("menu", 40, 34, 20, 15, "fill") then
		gui.row("dynamic", 3, 1)
		if gui.button("Play") then gui.switch("menu", "")  end
		if gui.button("Settings") then gui.switch("menu", "settings") end
		if gui.button("Quit") then love.event.quit() end
  end

  -- settings(center, escape to return to menu)
  if gui.begin("settings", 25, 20, 50, 60, "fill") then
		gui.row("dynamic", 3, 1)
		if gui.button("Setting 1") then print("setting 1") end
		if gui.button("Setting 2") then print("setting 2") end
		value = gui.slider(0, value, 100, 1)
		gui.combo(combo)
		gui.keymap()
  end

  -- debug(top left, f3 to toggle)
  local name, version, vendor, device = love.graphics.getRendererInfo()
  if gui.begin("debug", 0, 0, 50, 30) then
	gui.row("dynamic", 1, 1)
	gui.label("fps " .. love.timer.getFPS())
	gui.label(name .. " " .. version)
	gui.label(vendor .. " " .. device)
	gui.label("memory " .. collectgarbage("count"))
	gui.label("time " .. os.date("%H:%M:%S"))
	gui.label("os " .. love.system.getOS())
  end
end
