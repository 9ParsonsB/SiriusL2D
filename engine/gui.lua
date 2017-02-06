gui = {}

gui.x, gui.y = 0, 0
gui.w, gui.h = 0, 0
gui.spacing = 10
gui.font = love.graphics.newFont(12)

gui.dx, gui.dy = 0, 0
gui.clicked = false

function gui.hover(x, y, w, h)
  local mx, my = love.mouse.getPosition()
  return mx > x and mx < x + w and my > y and my < y + h
end

function gui.begin(x, y, w, h, spacing)
  local sw, sh = love.graphics.getDimensions()
  gui.x, gui.y = math.floor(x * sw), math.floor(y * sh)
  gui.w, gui.h = math.floor(w * sw), math.floor(h * sh)
  gui.spacing = math.floor(spacing * sh)
end

function gui.update(dt)
  gui.clicked = false
end

function gui.mousepressed(x, y, btn)
  if btn == 1 then gui.clicked = true end
end

function gui.mousereleased(x, y, btn)
  
end

function gui.mousemoved(x, y, dx, dy)
  gui.dx, gui.dy = dx, dy
end

function gui.resize(w, h)
  -- recalculate x, y, w, h
end

function gui.label(text)
  love.graphics.push("all")
  love.graphics.setFont(gui.font)
  love.graphics.setColor(255, 255, 255)
  love.graphics.printf(text, gui.x, gui.y, gui.w, "left")
  love.graphics.pop()

  gui.y = gui.y + gui.h + gui.spacing
end

function gui.button(text)
  local state = gui.hover(gui.x, gui.y, gui.w, gui.h) and gui.clicked

  love.graphics.push("all")
  love.graphics.setFont(gui.font)

  if state then love.graphics.setColor(0, 76, 153)
  else love.graphics.setColor(64, 64, 64) end

  love.graphics.rectangle("fill", gui.x, gui.y, gui.w, gui.h)
  love.graphics.setColor(255, 255, 255)
  love.graphics.printf(text, gui.x, gui.y + (gui.h / 2) - 10, gui.w, "center")
  love.graphics.pop()

  gui.y = gui.y + gui.h + gui.spacing

  return state
end

function gui.textbox()
  
end

function gui.slider(value, left, right)
  -- if hover bar then move slider

  love.graphics.push("all")
  
  love.graphics.setColor(64, 64, 64)
  love.graphics.rectangle("fill", gui.x, gui.y, gui.w, gui.h)
  
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("fill", gui.x, gui.y, gui.w, gui.h)
  -- love.graphics.print(value, gui.x, gui.y)

  love.graphics.pop()
end

--[[function Ui.getTextHeight(text, limit)
  --Get number of lines
  local font = love.graphics.getFont()
  local rw, lines = font:getWrap(text, limit)

  --Get height of a line
  local lineheight = font:getLineHeight() * (font:getAscent() + font:getDescent())

  --Return total height
  return #lines * lineheight
end--]]
