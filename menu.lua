local menu = {}

function menu.update(dt)
 
end

function menu.draw()
  if ui.button("Start game", 200, 200) then state = "game" end
end

function menu.mousemoved(x, y, dx, dy)
  
end

function menu.keypressed(key)
  if key == "escape" then love.event.quit() end
  if key == "space" then state = "game" end
end

return menu