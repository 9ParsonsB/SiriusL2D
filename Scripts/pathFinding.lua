Map = Grid(100, 100, 3, 3)

function MousePressed(self, x, y, button, isTouch)
  if button == 1 then
    local path = Map:PathFind(100, 100, 190, 100) 
  end
end

function Draw(self)
  Map:Draw()
end