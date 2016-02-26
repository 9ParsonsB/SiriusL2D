local NetPeer = Class("NetPeer")

function NetPeer:Create(ip_or_packet,port,ptype,name,connected)
  local packet, ip
  if ip_or_packet.isvaild then packet = ip_or_packet connected = port else ip = ip_or_packet end
  
  self.ip = ip or packet
  self.port = port or packet.port
  self.peertype = ptype or packet.peertype
  self.name = name or packet.peername
  self.connected = connected
  self.lastpingtime = packet.receivedtime or 0
  self.ping = packet.receivedtime - packet.senttime or 0
end

return NetPeer