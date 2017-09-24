-- api wrap(love2d)
local t = require "core/math"
Vec = t[1]

<<<<<<< HEAD
ge.physics = love.physics

=======
>>>>>>> f54c48c6670be9d283fdd048b9c9a790edba36ca
ge.state = {}
ge.prev = {} 
ge.prev2 = {}
ge.wheel = {x=0, y=0}
ge.lastwheel = {x=0,y=0}
ge.delta = {x=0, y=0} 
ge.lastdelta = {x=0,y=0}
ge.textentered = ""

-- types
ge.ImageData = love.image.newImageData
ge.Texture = love.graphics.newImage
ge.Shader = love.graphics.newShader
ge.Font = love.graphics.newFont
ge.Sound = love.audio.newSource
ge.Thread = love.thread.newThread
ge.Vec = t[1]
ge.Camera = t[2]

-- util
ge.read = love.filesystem.read
ge.render = love.graphics.draw
ge.print = love.graphics.print
ge.rectangle = love.graphics.rectangle
ge.circle = love.graphics.circle
ge.line = love.graphics.line
<<<<<<< HEAD
ge.polygon = love.graphics.polygon
ge.setColour = love.graphics.setColor
ge.setBackgroundColour = love.graphics.setBackgroundColour
=======
>>>>>>> f54c48c6670be9d283fdd048b9c9a790edba36ca
ge.mouseX = love.mouse.getX
ge.mouseY = love.mouse.getY

function ge.Scene(title, width, height)
  return {title=title, width=width, height=height,update=updateScene}
end

function ge.mouse()
  local x, y = love.mouse.getPosition()
  return Vec(x, y)
end

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  math.randomseed(os.time())
  if ge.load then ge.load(arg) end
end

function love.update(dt)
  ge.updateInput(dt)
  gui.update(dt)
  if ge.update then ge.update(dt) end
end

-- testing aspect scaling(temp)
local sw, sh = love.graphics.getDimensions()
function love.draw()
  local w, h = love.graphics.getDimensions()
  -- love.graphics.origin()
  -- love.graphics.scale(w / sw, h / sh)
  if ge.draw then ge.draw() end
  if ge.transformed then 
    love.graphics.pop()
    ge.transformed = false
  end
  gui.draw()
end

ge.transformed = false
function ge.push(node)
<<<<<<< HEAD
  if ge.transformed then 
    ge.transformed = false
    love.graphics.pop() 
  end

  if node then
    ge.transformed = true
    love.graphics.push()
    if node then 
      love.graphics.translate(node.position.x, node.position.y)
    end
  end
=======
  if node and not node.position then return end
  if ge.transformed then love.graphics.pop() end
  ge.transformed = true
  love.graphics.push()
  love.graphics.translate(node.position.x, node.position.y)
>>>>>>> f54c48c6670be9d283fdd048b9c9a790edba36ca
end

function love.keypressed(key, scancode, isrepeat) 
  ge.state[key] = true 
  -- if ge.pressed then ge.pressed(key) end
end

function love.keyreleased(key) 
  ge.state[key] = false 
end

function love.textinput(t) 
  ge.textentered = ge.textentered .. t 
end

function love.mousepressed(x, y, button, istouch) 
  ge.state[button] = true 
end

function love.mousereleased(x, y, button, istouch) 
  ge.state[button] = false  
end

function love.mousemoved(x, y, dx, dy, istouch) 
  ge.lastdelta = {x=dx, y=dy} 
end

function love.wheelmoved(x, y) 
  ge.wheel = {x=x, y=y} 
end

function love.gamepadpressed(joystick, button)
  print("gamepad pressed" .. button)
end

function love.threaderror(thread, errorstring)
  error("Thread error ".. errorstring)
end

function table.copy(t1)
  local out = {}
  for k, v in pairs(t1) do out[k] = v end
  return out
end

function ge.updateInput(dt) 
  ge.delta = table.copy(ge.lastdelta)
  ge.wheel = table.copy(ge.lastwheel)
  ge.lastdelta = {x=0,y=0}
  ge.lastwheel = {x=0,y=0}
  ge.prev = table.copy(ge.prev2)
  ge.prev2 = table.copy(ge.state)
end

-- range -1 to 1
function ge.axis(bind)
  local value = 0
  if ge.down(bind[1]) then value = value - 1 end
  if ge.down(bind[2]) then value = value + 1 end
  return value
end

function ge.down(key) 
  return ge.state[key] 
end

function ge.pressed(key) 
  return not ge.prev[key] and ge.state[key] 
end

function ge.released(key) 
  return ge.prev[key] and not ge.state[key] 
end

local currentCamera
function ge.bind(shader, camera)
  love.graphics.setShader(shader)

  if not camera then
    if currentCamera then love.graphics.pop() end
    currentCamera = nil
    return
  end

  currentCamera = camera
  -- dimensions, center
  local w, h = love.graphics.getDimensions()
  local size = camera.position + Vec(w / 2, h / 2)
  
  -- scale to screen size
  love.graphics.push()
  love.graphics.scale(w / camera.iSize.x, h / camera.iSize.y)
  love.graphics.translate(w / 2, h / 2)
  love.graphics.scale(1 / camera.zoom)
  love.graphics.rotate(-math.rad(camera.r))
  love.graphics.translate(-camera.position.x - w / 2, -camera.position.y - h / 2)
end
