local Peer = require "Engine/Network/peer"
local Server = Class("Server", Peer)

-- Running at creation?
--local running = false

function Server:Start()
  self.udp:setsockname('*','7253')
  print 'listening on port 7253'
  self.Running = true
end

function Server:Update()
  Peer.Update(self)
end

  
  
function Server:HandleData(data,from,port)
  Peer.HandleData(self,data,from,port)
  if data == "Are you still there?" then
    udp:sendto("servername||people connected||motd||something else||relevant xkcd",msg_or_ip,port_or_nil)
    --else
    --print ("no data")
  end
end

function Server:sendToServer(data)
  if self.P2P then
    if self.server.connected then
      self.udp:sendto(data, self.server.ip, self.server.port)
    end
  else
    if self.udp:send(data) then
      return true
    end
    return
  end
end

return Server