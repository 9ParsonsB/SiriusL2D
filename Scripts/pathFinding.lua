Map = Grid(100, 100, 30, 10)
Path = {}

--Calculate path
function MousePressed(self, x, y, button, isTouch)
  if button == 1 then Path = Map:PathFind(100, 150, x, y) end
  if button == 2 then Map:Insert(x, y, 1, 1) end
end

--Draw map and path
function Draw(self)
  Map:Draw()
  if Scripts.Game.DebugMode then Map:DebugDraw() end
  Renderer.Lines(Path, {0, 0, 0})
end