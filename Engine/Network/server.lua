require "grease"
local Server = new Class("Server")
local socket = require("socket")
local world = {}
local data, msg_or_ip, port_or_nil
local running = false
function Server:Create()
  running = true
  print "Starting Server. Intergrated."
end
  
  
function Server:Update()
  
  data, msg_or_ip, port_or_nil = udp:receivefrom()
  
  if data then
    print "got data"
    print data
  else
    print "no data"
  end
  socket.sleep(0.01)
end