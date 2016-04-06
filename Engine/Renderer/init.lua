local Content = require "Engine/Renderer/content"
local R,G,B,A = 0, 0, 0, 0
Renderer = {}

--Set colour for rendering
function Renderer.SetColour(colour)
  colour = colour or {255, 255, 255}
  R, G, B, A = love.graphics.getColor()
  love.graphics.setColor(colour)
end

--Reset colour to what it was
function Renderer.ResetColour()
  love.graphics.setColor(R, G, B, A)
end

--Draw box
function Renderer.Box(x, y, width, height, colour, mode)
  Renderer.SetColour(colour)
  love.graphics.rectangle(mode or "fill", x, y, width, height)
  Renderer.ResetColour()
end

--Draw line
function Renderer.Line(x1, y1, x2, y2, colour)
  Renderer.SetColour(colour)
  love.graphics.line(x1, y1, x2, y2)
  ResetColour()
end

--Draw table of lines
function Renderer.Lines(lines, colour)
  Renderer.SetColour(colour)
  for i=1, #lines-1 do love.graphics.line(lines[i].X, lines[i].Y, lines[i+1].X, lines[i+1].Y) end
  Renderer.ResetColour()
end

--Draw a path
--[[function DrawPath(self, path, colour)
  if #self.Path > 0 then
    DrawLine(self.X, self.Y, self.Path[1].X, self.Path[1].Y, colour)
    DrawLines(self.Path, colour)
  end
end--]]

--Draw sprite
function Renderer.Sprite(filePath, x, y, angle, scaleX, scaleY, offsetX, offsetY)
  local texture = Content.LoadTexture(filePath)

  --Default values
  x, y = x or 0, y or 0
  angle = angle or 0
  scaleX = scaleX or 1
  scaleY = scaleY or 1

  --Draw sprite
  love.graphics.draw(
  texture, 
  x, y, 
  (math.pi / 180) * angle, 
  scaleX, scaleY, 
  offsetX or texture:getWidth() / 2, offsetY or texture:getHeight() / 2)
end

--Update animation
function Renderer.UpdateAnimation(self, dt)
  local file = Content.LoadAnimation(self.Animation)

  --Controls playback rate of animation
  self.Timer = self.Timer + dt
  if self.Timer <= file.FrameDuration then return end   

  --If we reached the last frame of this animation
  if self.Frame >= #file[self.State] then      

    --Play any transitions
    local state = file.Transitions[self.State]
    if state then 
      self:PlayAnimation(state) 
    else

      --If animation should loop
      if self.Loop then
        self.Frame = 1 
      end
    end

  --Move through animation
  else 
    self.Frame = self.Frame + 1 
  end  

  --Reset timer
  self.Timer = 0  
end

--Draw animation
function Renderer.DrawAnimation(self)
  local file = Content.LoadAnimation(self.Animation)
  local texture = Content.LoadTexture(file.SpriteSheet)
  local frame = file[self.State][self.Frame]

  quad = love.graphics.newQuad(frame.X, frame.Y, frame.Width, frame.Height, texture:getWidth(), texture:getHeight())

  --Draw sprite
  love.graphics.draw(
  texture, 
  quad,
  self.X, self.Y, 
  math.rad(self.Angle), 
  1, 1, 
  frame.Width / 2, frame.Height / 2)
end