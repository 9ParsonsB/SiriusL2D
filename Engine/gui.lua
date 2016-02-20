GUI = {}
function GUI.Button(texture, x, y, width, height)
  Renderer.DrawSprite(texture, x, y, 0, width, height, 0, 0)
  return GUI.MouseOver(x, y, width, height) 
  and love.mouse.isDown(1)
end

--Checks if mouse over area
 function GUI.MouseOver(x, y, width, height)
   local mouseX, mouseY = love.mouse.getPosition()
   return mouseX > x and mouseX < x + width
   and mouseY > y and mouseY < y + height
 end