Camera.Dragging = false
Camera.MoveScale = 2
Camera.MoveSpeed = 1000

--Arrow key controls
function Camera:Update(dt)
  local x, y = 0, 0

  if love.keyboard.isDown("up") then y = -self.MoveSpeed end
  if love.keyboard.isDown("down") then y = self.MoveSpeed end
  if love.keyboard.isDown("left") then x = -self.MoveSpeed end
  if love.keyboard.isDown("right") then x = self.MoveSpeed end

  if not self.Dragging then Camera:Move(x * dt, y * dt) end
end

--Middle mouse controls
function Camera:MousePressed(x, y, button, isTouch)
  self.Dragging = button == 3
end

--Release control of camera
function Camera:MouseReleased(x, y, button)
  if button == 3 then self.Dragging = false end
end

--Move camera if its selected
function Camera:MouseMoved(x, y, dx, dy)
  if self.Dragging then Camera:Move(-dx, -dy) end
end

--Zoom the camera in and out
function Camera:WheelMoved(x, y)
  --Camera:Scale(-y, -y)
end