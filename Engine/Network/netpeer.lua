local NetPeer = Class("NetPeer")

function NetPeer:Create(ip,port,ptype,name,connected)
  self.ip = ip
  self.port = port
  self.peertype = ptype
  self.name = name
  self.connected = connected
  self.lastpingtime = 0
  self.lastattemptedpingtime = 0
end

return NetPeer