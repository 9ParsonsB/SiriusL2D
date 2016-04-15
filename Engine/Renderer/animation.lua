local Content = require "Engine/Renderer/content"
local Animation = Class("Animation")

Animation.Frame = 1
Animation.Timer = 0

function Animation:Create(filePath, state, loop)
  self.FilePath = filePath
  self.State = state
  self.Loop = loop
end

function Animation:ChangeState(state, loop)
  self.Frame = 1
  self.Timer = 0
  self.State = state
  self.Loop = loop
end

function Animation:Update(dt)
  local file = Content.LoadAnimation(self.FilePath)

  --Controls playback rate of animation
  self.Timer = self.Timer + dt
  if self.Timer <= file.FrameDuration then return end   

  --If we reached the last frame of this animation
  if self.Frame >= #file[self.State] then      

    --Play any transitions
    local state = file.Transitions[self.State]
    if state then 
      self:ChangeState(state, self.Loop)
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

function Animation:Draw(object)
  local file = Content.LoadAnimation(self.FilePath)
  local texture = Content.LoadTexture(file.SpriteSheet)

  --Area of sprite sheet to draw
  local frame = file[self.State][self.Frame]
  quad = love.graphics.newQuad(frame.X, frame.Y, frame.Width, frame.Height, texture:getWidth(), texture:getHeight())

  --Draw sprite
  love.graphics.draw(
  texture, 
  quad,
  object.Position.X, object.Position.Y, 
  math.rad(object.Angle), 
  1, 1, 
  frame.Width / 2, frame.Height / 2)
end
return Animation