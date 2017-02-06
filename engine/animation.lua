local Animation = class("Animation")

Animation.Frame = 1
Animation.Timer = 0

function Animation:Create(filePath, state, loop)
  self.filepath = filePath
  self.state = state
  self.loop = loop
end

function Animation:ChangeState(state, loop)
  self.frame = 1
  self.timer = 0
  self.state = state
  self.loop = loop
end

function Animation:Update(dt)
  local file = Content.LoadAnimation(self.FilePath)

  --Controls playback rate of animation
  self.timer = self.timer + dt
  if self.timer <= file.frameDuration then return end   

  --If we reached the last frame of this animation
  if self.frame >= #file[self.state] then      

    --Play any transitions
    local state = file.Transitions[self.state]
    if state then 
      self:ChangeState(state, self.loop)
    else

      --If animation should loop
      if self.loop then
        self.frame = 1 
      end
    end

  --Move through animation
  else 
    self.frame = self.frame + 1 
  end  

  --Reset timer
  self.timer = 0  
end

function Animation:Draw(object)
  local file = Content.loadAnimation(self.filePath)
  local texture = Content.loadTexture(file.SpriteSheet)

  --Area of sprite sheet to draw
  local frame = file[self.state][self.frame]
  quad = love.graphics.newQuad(frame.X, frame.Y, frame.width, frame.height, texture:getWidth(), texture:getHeight())

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