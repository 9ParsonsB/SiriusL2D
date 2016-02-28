local NetPeer = Class("NetPeer")

function NetPeer:Create(packet,connected)
  if not packet.isvaild then return false end
  
  self.ip = packet.sender
  self.port = packet.port
  self.peertype = packet.sendertype
  self.name = packet.peername
  self.connected = connected
  self.lastpingtime = packet.receivedtime or 0
  self.ping = packet.receivedtime - packet.senttime or 0
end

return NetPeer