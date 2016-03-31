Renderer = {
  Camera = require "Engine/Renderer/camera",

  R,G,B,A = 0, 0, 0, 0,

  ContentDir = "Content/", 
  Textures = {},

  AnimationFiles = {},
  Animations = {}
}

--Set colour for rendering
function Renderer.SetColour(colour)
  colour = colour or {255, 255, 255}
  Renderer.R, Renderer.G, Renderer.B, Renderer.A = love.graphics.getColor()
  love.graphics.setColor(colour)
end

--Reset colour to what it was
function Renderer.ResetColour()
  love.graphics.setColor(Renderer.R, Renderer.G, Renderer.B, Renderer.A)
end

--Draw box
function Renderer.Box(x, y, width, height, colour)
  Renderer.SetColour(colour)
  love.graphics.rectangle("fill", x, y, width, height)
  Renderer.ResetColour()
end

--Draw line
function Renderer.Line(x1, y1, x2, y2, colour)
  Renderer.SetColour(colour)
  love.graphics.line(x1, y1, x2, y2)
  Renderer.ResetColour()
end

--Draw table of lines
function Renderer.Lines(lines, colour)
  Renderer.SetColour(colour)
  for i=1, #lines-1 do love.graphics.line(lines[i].X, lines[i].Y, lines[i+1].X, lines[i+1].Y) end
  Renderer.ResetColour()
end

--Draw a path
function Renderer.Path(self, path, colour)
  if #self.Path > 0 then
    Renderer.Line(self.X, self.Y, self.Path[1].X, self.Path[1].Y, colour)
    Renderer.Lines(self.Path, colour)
  end
end

function Renderer.GetTexture(filePath)
  if Renderer.Textures[filePath] then return Renderer.Textures[filePath] end
  local texture = love.graphics.newImage(Renderer.ContentDir .. filePath)
  Renderer.Textures[filePath] = texture
  return texture
end

function Renderer.Sprite(filePath, x, y, angle, scaleX, scaleY, offsetX, offsetY)
  local texture = Renderer.GetTexture(filePath)

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

function Renderer.SpriteArea(filePath, x, y, angle, frame)
  local texture = Renderer.GetTexture(filePath)

  --Default values
  x, y = x or 0, y or 0
  angle = angle or 0
  quad = love.graphics.newQuad(frame.X, frame.Y, frame.Width, frame.Height, texture:getWidth(), texture:getHeight())

  --Draw sprite
  love.graphics.draw(
  texture, 
  quad,
  x, y, 
  (math.pi / 180) * angle, 
  1, 1, 
  texture:getWidth() / 2, texture:getHeight() / 2)
end

function Renderer.GetAnimation(filePath)
  if Renderer.AnimationFiles[filePath] then return Renderer.AnimationFiles[filePath] end

  --Animation enviroment
  local animation = setmetatable({States={}}, {__index = _G})
  function animation.AddFrame(state, x, y, width, height)
    animation[state] = animation[state] or {}
    table.insert(animation[state], {X = x, Y = y, Width = width, Height = height})
  end

  --Load animation
  local chunk = love.filesystem.load(Renderer.ContentDir .. filePath .. ".lua")
  setfenv(chunk, animation)
  chunk()
  Renderer.AnimationFiles[filePath] = animation

  return animation
end

function Renderer.Animation(self, filePath, state, loop)
  local animation = Renderer.Animations[self] 
  local file = Renderer.GetAnimation(filePath)

  --If state doesn't exist
  if not file[state] then return end

  --Create new animation if one does not exist or file/state has changed
  if not animation or filePath ~= animation.FilePath or state ~= animation.State then
    animation = {Timer = 0, Frame = 1, FilePath = filePath, State = state}
  end

  --Change frame
  animation.Timer = animation.Timer + love.timer.getDelta()
  if animation.Timer >= file.FrameDuration then

    if animation.Frame >= #file[state] then 
      if loop then animation.Frame = 1 end
    else 
      animation.Frame = animation.Frame + 1 
    end
    animation.Timer = 0
  end

  --Draw current frame
  local frame = file[state][animation.Frame]
  Renderer.SpriteArea(file.SpriteSheet, self.X, self.Y, self.Angle, frame)

  --Store animation data
  Renderer.Animations[self] = animation
end