local socket = require "socket"
local address, port = "siriusgame.ddns.net", 7253 --TODO: make configurable



local updaterate = 0.1
local t

local Peer = require "Engine/Network/peer"
local Client = Class("Client", Peer)

function Client:Create(peername)
  Peer.Create(self,peername)
  self.server = {}
end

function Client:Connect(addr,port)
  port = port or self.port or 7253
  name, alias, ip = self.socket.dns.toip(addr)
  if not ip then
    ip = addr
    print("IP returned nil, attempting direct addr connect.")
  end
  
  if self.Connecting then
    
  end
  
  if not self.server.connected then
    if self.P2P then
      --[[print("pinging: " .. ip .. ":"..port)
      packet = Peer:Packet("conn")
      self:SendPacket(packet,ip)
      print("waiting for pong for 5 seconds")
      self.Connecting = {ip = ip, port = port, time = self.socket.gettime()}]]--
    else
      local p,i = self:getNetPeerFromIP(ip)
      p = p or {connected = false}
      if not self.server.connected  and not self.Connecting and not p.connected then
        print("connecting to: " .. ip .. ":"..port)
        packet = Peer:Packet("conn")
        self:SendPacket(packet,ip)
        print("waiting for ack for 5 seconds")
        self.Connecting = {ip = ip, port = port, time = self.socket.gettime()}
      else
        if p.connected then
          error("Already connected to that host.")
        end
      end
    end
  else
    error("Already server.connected!")
  end
end


function Client:Start() end

function Client:Update() 
  Peer.Update(self)
end



function Client:HandleData(packet) --TODO MOVE STUFF FROM PEER TO CLIENT / SERVER
  self.Super.HandleData(self,packet)
end

function Client:Debug() end

return Client