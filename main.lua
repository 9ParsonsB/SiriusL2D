require "engine"

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  menu = false 
  debug = true
end

function love.update(dt)
  rts.update(dt)
  gui.update(dt)
end

function love.draw()
  rts.draw()
  if menu then love.menu() end
  if debug then love.debug() end
end

function love.menu()
  gui.begin(0.4, 0.35, 0.2, 0.05, 0.01)
  if gui.button("start game") then print("start") end
  if gui.button("settings") then print("settings") end
  if gui.button("quit") then love.event.quit() end
end

function love.debug()
  local name, version, vendor, device = love.graphics.getRendererInfo()
  gui.begin(0, 0, 0.5, 0.02, 0)
  gui.label("fps: " .. love.timer.getFPS())
  gui.label(name .. " " .. version)
  gui.label(vendor .. " " .. device)
  gui.label("pos x: " .. rts.px .. " y: " .. rts.py)
end

function love.keypressed(key)
  if (key == "escape") then menu = not menu end
  if (key == "f3") then debug = not debug end
end

function love.mousepressed(x, y, btn)
  rts.mousepressed(x, y, btn)
  gui.mousepressed(x, y, btn)
end

function love.mousereleased(x, y, btn)
  rts.mousereleased(x, y, btn)
  gui.mousereleased(x, y, btn)
end

function love.mousemoved(x, y, dx, dy)
  rts.mousemoved(x, y, dx, dy)
  gui.mousemoved(x, y, dx, dy)
end
