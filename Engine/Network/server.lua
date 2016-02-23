local Server = Class("Server","Peer")
local socket = require("socket")

-- Use P2P
local hybrid = false

-- Running at creation?
--local running = false


function Server:Start()
  udp:setsockname('*','7253')
  print 'listening on port 7253'
  self.Running = true
end
  
  
function Server:HandleData(data,from,port)
  print("got data")
  print(data)
  if data == "Are you still there?" then
    udp:sendto("servername||people connected||motd||something else||relevant xkcd",msg_or_ip,port_or_nil)
    --else
    --print ("no data")
  end
end

return Server