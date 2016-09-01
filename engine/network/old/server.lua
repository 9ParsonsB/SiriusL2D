local Peer = require "Engine/Network/peer"
local Server = Class("Server", Peer)

-- Running at creation?
--local running = false

function Server:Start(name)
  self.udp:setsockname('*','7253')
  print 'listening on port 7253'
  self.Running = true
  if name then
    self.peername = name
  end
end

function Server:Update()
  Peer.Update(self)
end

  
  
function Server:HandleData(packet)
  self.Super.HandleData(self,packet)
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