Map = Grid(100, 100, 3, 3)
Path = {}

--Calculate path
function MousePressed(self, x, y, button, isTouch)
  if button ~= 1 then return end
  Path = Map:PathFind(100, 115, 190, 115) 
end

--Draw map and path
function Draw(self)
  Map:Draw()
  Renderer.Lines(Path, {0, 0, 0})
end