function love.conf(t)
  io.stdout:setvbuf("no")

  t.window.title = "Space game"
  t.window.width = 1600
  t.window.height = 900
  t.window.vsync = false
  t.window.msaa = 8
  t.window.resizable = true  
end