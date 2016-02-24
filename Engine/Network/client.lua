local socket = require "socket"
local address, port = "siriusgame.ddns.net", 7253 --TODO: make configurable



local updaterate = 0.1
local t

local Peer = require "Engine/Network/peer"
local Client = Class("Client", Peer)

function Client:Create()
  Peer.Create(self,"CLEINT")
  self.server = {}
end

function Client:handleConnectionResponse(packet)
  if self.Connecting then
    if data:match("ack") and from == self.Connecting.ip and port == self.Connecting.port then 
      local split = data:split("@")
      ptype = split[1]
      pname = split[2]
      print("inserting :" ..pname.. ". into peer table.")
      table.insert(self.netPeers,Network.NetPeer(ip,port,ptype,name,false))
      if ptype:lower():match("server") then
        self.server.name = pname
        self.server.type = ptype
        self.server.ip = from
        self.server.port = port
        self.server.connected = true        
      end
      self.Pining = nil
    end  
  end
  Peer.handlePong(self,data,from,port)
end


function Client:Connect(addr,port)
  name, alias, ip = self.socket.dns.toip(addr)
  if not ip then
    ip = addr
    print("IP returned nil, attempting direct addr connect.")
  end
  
  if not self.server.connected then
    if self.P2P then
      print("pinging: " .. ip .. ":"..port)
      self.udp:sendto("ping" .. self.getSelfID(self),ip,port)
      print("waiting for pong for 5 seconds")
      self.Connecting = {ip = ip, port = port, time = self.socket.gettime()}
    else
      p,i = self:getNetPeerByIP(ip)
      p = p or {connected = false}
      if not self.server.connected  and not self.Connecting and not p.connected then
        print("connecting to: " .. ip .. ":"..port)
        self.udp:sendto("conn" .. self.getSelfID(self),ip,port)
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



function Client:HandleData(packet) --TODO MOVE STUFF FROM PEER TO CLEITN / SERVERERE
  Peer.HandleData(self,packet)
end

function Client:Debug() end

return Client