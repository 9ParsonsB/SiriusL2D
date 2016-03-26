Map = Transform.Grid(100, 100, 40, 20)

function MousePressed(self, x, y, button, isTouch)
  if button == 2 then Map:Toggle(x, y) end
end

function Find(x1, y1, x2, y2)
  return Map:PathFind(x1, y1, x2, y2)
end

function Draw(self)
  Map:Draw()
  if Scripts.Game.DebugMode then Map:DebugDraw() end
end