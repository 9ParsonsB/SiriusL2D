lua coskets
local Server = new Class("Server")
local socket = require("socket")
local udp
local world = {}
local data, msg_or_ip, port_or_nil
local pdata
local running = false

function Server:Create()
  running = true
  print "Starting Server. Intergrated."
  udp = socket.udp()
  udp:settimeout(0)
  udp:setsockname('*',7253)
end
  
  
function Server:Update()
  
  data, msg_or_ip, port_or_nil = udp:receive()
  
  if data then
    print "got data"
    print data
  else
    print "no data"
  end
  socket.sleep(0.01)
end