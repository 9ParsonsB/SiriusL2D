local Peer = require "Engine/Network/peer"
local Server = Class("Server", Peer)

-- Running at creation?
--local running = false

function Server:Start()
  self.udp:setsockname('*','7253')
  print 'listening on port 7253'
  self.Running = true
end
  
  
function Server:HandleData(data,from,port)
  Peer:HandleData(self)
  if data == "Are you still there?" then
    udp:sendto("servername||people connected||motd||something else||relevant xkcd",msg_or_ip,port_or_nil)
    --else
    --print ("no data")
  end
end

return Server