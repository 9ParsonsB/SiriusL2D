io.stdout:setvbuf("no")

function love.conf(t)
  t.window.title = "Sirius"
  t.window.width = 1024
  t.window.height = 768
  t.window.vsync = true
  t.window.msaa = 8
  t.window.resizable = true  
end
