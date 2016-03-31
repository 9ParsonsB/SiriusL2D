Class("CameraControl")

CameraControl.Move = false
CameraControl.MoveScale = 2
CameraControl.MoveSpeed = 1000

function CameraControl:Create()
  Scene.Add(self)
  --love.mouse.setGrabbed(true)
end

function CameraControl:Update(dt)
  --Arrow key controls
  local x, y = 0, 0

  if love.keyboard.isDown("up") then y = -self.MoveSpeed end
  if love.keyboard.isDown("down") then y = self.MoveSpeed end
  if love.keyboard.isDown("left") then x = -self.MoveSpeed end
  if love.keyboard.isDown("right") then x = self.MoveSpeed end

  if not self.Move then Scene.Camera:Move(x * dt, y * dt) end
end

--Middle mouse controls
function CameraControl:MousePressed(x, y, button, isTouch)
  self.Move = button == 3
end

function CameraControl:MouseReleased(x, y, button)
  if button == 3 then self.Move = false end
end

function CameraControl:MouseMoved(x, y, dx, dy)
  if self.Move then Scene.Camera:Move(-dx, -dy) end
end

--Zooming
function CameraControl:WheelMoved(x, y)
  Scene.Camera:Scale(-y, -y)
end