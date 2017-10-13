gui = {}

local style = {
	BACK = {124, 124, 124, 200},
	TEXT = {255, 255, 255, 255},
	IDLE = {100, 100, 100, 255},
	HOVER = {60, 60, 60, 255},
	PRESSED = {30, 30, 30, 255}
}
gui.style = style

local commands = {}
local space = 5
local index = 1
local cols = 1
local padding = 10
local box = {x=0,y=0,w=100,h=20}
local toggles = {}
local pressed = false
local screen = "home"

function gui.play(name)
	screen = name
end

function gui.toggle(key, state, self, callback)
	local toggle = {}
	toggle.key = key
	toggle.callback = callback
	toggle.state = state
	toggle.self = self
  	toggles[key] = toggle
end

function gui.update(dt)
  	commands = {}
	box = {x=0,y=0,w=100,h=20}

	for k,v in pairs(toggles) do
		if ge.pressed(v.key) then v.state = not v.state end
		if v.state then v.callback(v.self) end
	end
	pressed = ge.pressed(1)
end

function gui.draw()
	love.graphics.push("all")
	for k,v in pairs(commands) do v() end
	commands = {}
	love.graphics.pop()
end

-- rectangle draw command(gui.draw)
function gui.rectangle(mode, x, y, w, h, rx, ry, colour)
	colour = colour or style.IDLE
	table.insert(commands, function ()
		love.graphics.setColor(colour)
		love.graphics.rectangle(mode, x, y, w, h, rx, ry)
	end)
end

-- text draw command(gui.draw)
function gui.printf(text, x, y, limit, align)
	table.insert(commands, function ()
		love.graphics.setColor(style.TEXT)
		love.graphics.printf(text, x, y, limit, align)
	end)
end

function gui.begin(name, x, y, w, h)
	box = {x=x,y=y,w=w,h=h}
	return screen == name
end

function gui.advance()
	box.y = box.y + box.h + space
end

function gui.hover()
	local mouse = ge.mouse()
	return ge.contains(mouse.x, mouse.y, box.x, box.y, box.w, box.h)
end

function gui.state()
	local hover = gui.hover()
	if hover and pressed then return "PRESSED" end
	if hover then return "HOVER" end
	return "IDLE"
end

-- text display control
function gui.label(text, align)
	gui.printf(text, box.x, box.y, box.w, align or "left")
	gui.advance()
end

-- standard button that is presses once
function gui.button(text)
	local state = gui.state()

	local font = love.graphics.getFont()
	local height = font:getHeight() / 2
	local textY = box.y + (box.h / 2) - height

	gui.rectangle("fill", box.x, box.y, box.w, box.h, 5, 5, style[state])
	gui.printf(text, box.x, textY, box.w, "center")
	gui.advance()
  
	return state == "PRESSED"
end

function gui.load() end
function gui.quit() end
function gui.textinput(t) end
function gui.keypressed(key, scancode, isrepeat) end
function gui.keyreleased(key) end
function gui.mousemoved(x, y, dx, dy, istouch) end
function gui.mousepressed(x, y, button, istouch) end
function gui.mousereleased(x, y, button, istouch) end
function gui.wheelmoved(x, y) end
