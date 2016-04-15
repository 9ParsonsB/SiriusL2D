require "Engine/Renderer/camera"

local Content = require "Engine/Renderer/content"
local Animation = require "Engine/Renderer/animation"

local R,G,B,A = 0, 0, 0, 0

Renderer = {
  Animations = {}
}

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

function Renderer.SetBackgroundColour(r, g, b, a)
  love.graphics.setBackgroundColor(r, g, b, a)
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
function Renderer.Sprite(filePath, x, y, angle, width, height)
  local texture = Content.LoadTexture(filePath)

  --Size of sprite
  local textureWidth, textureHeight = texture:getDimensions()
  width, height = width or textureWidth, height or textureHeight

  --Draw sprite
  love.graphics.draw(
  texture, 
  x, y, 
  math.rad(angle), 
  width / textureWidth, height / textureHeight, 
  texture:getWidth() / 2, texture:getHeight() / 2)
end

function Renderer.Animation(self, filePath, state, loop)
  Renderer.Animations[self] = Animation(filePath, state, loop)
end