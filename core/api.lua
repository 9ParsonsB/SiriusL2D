-- api wrap(love2d)

require "core/reload"

ge.pressedState = {}
ge.releasedState = {}
ge.wheel = {x=0, y=0}
ge.lastwheel = {x=0,y=0}
ge.delta = {x=0, y=0} 
ge.lastdelta = {x=0,y=0}
ge.textentered = ""
ge.states = {}
ge.choice = {}
ge.active = nil

ge.ImageData = love.image.newImageData
ge.Texture = love.graphics.newImage
ge.Shader = love.graphics.newShader
ge.Font = love.graphics.newFont
ge.Sound = love.audio.newSource
ge.Thread = love.thread.newThread

ge.quit = love.event.quit
ge.read = love.filesystem.read
ge.draw = love.graphics.draw
ge.print = love.graphics.print
ge.rectangle = love.graphics.rectangle
ge.circle = love.graphics.circle
ge.line = love.graphics.line
ge.polygon = love.graphics.polygon
ge.setColour = love.graphics.setColor
ge.setBackgroundColour = love.graphics.setBackgroundColor
ge.setIcon = love.window.setIcon

function ge.Window(title, width, height)
  return {title=title, width=width, height=height}
end

function ge.State(name, t)
  ge.states[name] = {}
  return ge.states[name]
end

function ge.play(name)
  local state = ge.states[name]
  if state == ge.active then return end
  if not state then return end
  ge.active = state
  ge.call("Load")
end

function ge.restart()
  ge.call("Load")
  gui.play("")
end

function ge.call(name, ...)
  if ge.active and type(ge.active[name]) == "function" then 
    ge.active[name](ge.active, ...) 
  end 
end

function ge.drawf(texture, align, x, y, r, sx, sy)
  local ox, oy = 0, 0
  if align == "center" then
    ox = texture:getWidth() / 2
    oy = texture:getHeight() / 2
  end
  ge.draw(texture, x, y, r, sx, sy, ox, oy)
end

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  math.randomseed(os.time())
  ge.setBackgroundColour(74, 74, 74)
  ge.play("menu")
  gui.toggle("f3", true, nil, ge.debug)
  gui.load()
end

function love.quit()
  gui.quit()
end

function love.update(dt)
  gui.update(dt)
  ge.call("Update", dt)
  ge.call("Ui", dt)
  if menu then menu(dt) end
  ge.input(dt)
  ge.reload(dt)
end

function love.draw()
  if ge.transformed then 
    love.graphics.pop()
    ge.transformed = false
  end
  ge.call("Draw")
  ge.push()
  gui.draw()
end

ge.transformed = false
function ge.push(node)
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
end

function love.textinput(t) 
  ge.textentered = ge.textentered .. t 
  gui.textinput(t)
end

function love.keypressed(key, scancode, isrepeat) 
  ge.pressedState[key] = 1 
  gui.keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
  ge.releasedState[key] = 1
  gui.keyreleased(key, scancode)
end

function love.mousemoved(x, y, dx, dy, istouch) 
  ge.lastdelta = {x=dx, y=dy} 
  gui.mousemoved(x, y, dx, dy, istouch)
end

function love.mousepressed(x, y, button, istouch) 
  ge.pressedState[button] = 1 
  gui.mousepressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch) 
  ge.releasedState[button] = 1  
  gui.mousereleased(x, y, button, istouch)
end

function love.wheelmoved(x, y) 
  ge.wheel = {x=x, y=y} 
  gui.wheelmoved(x, y)
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

function ge.input(dt) 
  ge.delta = table.copy(ge.lastdelta)
  ge.wheel = table.copy(ge.lastwheel)
  ge.lastdelta = {x=0,y=0}
  ge.lastwheel = {x=0,y=0}
  ge.pressedState = {}
  ge.releasedState = {}
end

function ge.mouse()
  local x, y = love.mouse.getPosition()
  return ge.Vector2(x, y)
end

-- range -1 to 1
function ge.axis(bind)
  local value = 0
  if ge.down(bind[1]) then value = value - 1 end
  if ge.down(bind[2]) then value = value + 1 end
  return value
end

function ge.down(key) 
  return ge.state[key] == 1
end

function ge.pressed(key) 
  return ge.pressedState[key] == 1
end

function ge.released(key) 
  return ge.releasedState[key] == 1
end
