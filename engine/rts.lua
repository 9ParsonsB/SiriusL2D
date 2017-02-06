rts = {}

rts.tiles = {}
rts.objects = {}
rts.selection = {}

rts.box = false
rts.bx, rts.by = 0, 0

rts.cx, rts.cy = 0, 0
rts.px, rts.py = 175, 175

rts.overMap = false
rts.controlMap = false

function rts.spawn(x, y, w, h)
  local object = {x=x, y=y, w=w, h=h}
  table.insert(rts.objects, object)
end

function rts.command(name, x, y)
  -- for k,v in pairs(rts.objects) do end
end

function rts.update(dt)
  -- local s = math.floor(300 * dt)
  -- if (love.keyboard.isDown("w")) then rts.py = rts.py - s end
  -- if (love.keyboard.isDown("a")) then rts.px = rts.px - s end
  -- if (love.keyboard.isDown("s")) then rts.py = rts.py + s end
  -- if (love.keyboard.isDown("d")) then rts.px = rts.px + s end
  -- for k,v in pairs(rts.objects) do end

  rts.overMap = gui.hover(0, 568, 200, 200)

  --if rts.overMap then rts.box = false end

  if rts.controlMap then
    local s = 1000 / 200
    local x, y = love.mouse.getPosition()
    rts.cx, rts.cy = x * s, (y - 568) * s 
  end
end

function rts.draw()
  -- world
  love.graphics.setCamera(rts.cx, rts.cy)
  map.draw(true)
  love.graphics.setColor(0, 255, 0)
  love.graphics.rectangle("fill", rts.px - 10, rts.py - 10, 20, 20)
  -- for k,v in pairs(rts.objects) do end

  -- selection box
  if rts.box then  
  	local x, y = love.mouse.getPosition()
  	local w, h = (rts.cx - love.graphics.getWidth() / 2 + x) - rts.bx, (rts.cy - love.graphics.getHeight() / 2 + y) - rts.by
    love.graphics.setLineWidth(3)
    love.graphics.setColor(100, 149, 237)
    love.graphics.rectangle("line", rts.bx, rts.by, w, h)
    love.graphics.setLineWidth(1)
  end
  love.graphics.resetCamera()

  -- minimap 
  love.graphics.setColor(64, 64, 64)
  love.graphics.rectangle("fill", 0, 568, 200, 200)
  love.graphics.setViewport(0, 568, 200, 200, 1000, 1000)

  -- map.draw(false)
  love.graphics.setColor(0, 255, 0)
  love.graphics.rectangle("fill", rts.px, rts.py, 20, 20)

  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("line", rts.cx - love.graphics.getWidth() / 2, rts.cy - love.graphics.getHeight() / 2, 1024, 768)
  love.graphics.resetViewport()
end

function rts.mousepressed(x, y, btn)
  -- local object = nil
  -- for k, v in pairs(rts.objects) do 
  -- 	if hover then object = v end
  -- end
  -- if object then return end

  if btn == 1 and rts.overMap then rts.controlMap = true end

  -- start box select
  if btn == 1 and not rts.overMap then
	rts.box = true
	rts.bx = rts.cx - love.graphics.getWidth() / 2 + x
	rts.by = rts.cy - love.graphics.getHeight() / 2 + y
  end
end

function rts.mousereleased(x, y, btn)
  rts.box = false
  rts.controlMap = false
end

function rts.mousemoved(x, y, dx, dy)
  if love.mouse.isDown(3) and not rts.overMap then 
    rts.cx, rts.cy = rts.cx - dx, rts.cy - dy
  end
end
