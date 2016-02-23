local Server = Class("Server")
local socket = require("socket")

-- Use P2P
local hybrid = false

local udp = socket.udp()
local world = {}
local data, msg_or_ip, port_or_nil
local pdata

-- Running at creation?
local running = false

function Server:Create()
  udp:settimeout(0)
  udp:setsockname('*','7253')
  print 'listening on port 7253'
  running = true
  print "Starting Server. Intergrated."
end
  
  
function Server:Update()
  
  data, msg_or_ip, port_or_nil = udp:receivefrom()
  
  if data then
    print("got data")
    print(data)
  else
    print ("no data")
  end
  socket.sleep(0.01)
end
return Server