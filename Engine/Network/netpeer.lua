local NetPeer = Class("NetPeer")

function NetPeer:Create(ip,port,ptype,name,connected)
  self.ip = ip
  self.port = port
  self.peertype = ptype
  self.name = name
  self.connected = connected
end

return NetPeer