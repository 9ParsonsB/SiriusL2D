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

function Client:handlePong(data,from,port)
  Peer.handlePong(data,from,port)
  if self.Pinging then
    if string.match(data,"pong") and from == self.Pinging.ip and port == self.pining.port then 
      ping,ptype,pname = split(data,"$")
      if string.match(ptype.lower(),"server") then
        self.server.name = pname
        self.server.type = ptype
        self.server.ip = from
        self.server.port = port
        self.server.connected = true
      end
    end  
  end
end


function Client:Connect(addr,port)
  name, alias, ip = self.socket.dns.toip(addr)
  if not ip then
    ip = addr
    print("IP returned nil, attempting direct addr connect.")
  end
  
  if not self.server.connected then
    if self.P2P then
      self.udp:sendto("ping" .. self.getSelfID(self),ip,port)
      print("waiting for pong for 5 seconds")
      self.Pinging = {ip = ip, port = port, time = love.timer.getTime()}
    else
      if not self.server.connected  and not self.Pinging then
        self.udp:sendto("ping" .. self.getSelfID(self),ip,port)
        print("waiting for pong for 5 seconds")
        self.Pinging = {ip = ip, port = port, time = love.timer.getTime()}
      end
    end
  else
    error("Already server.connected!")
  end
end


function Client:Start() end

function Client:Update() 
  if self.Connected or self.Pinging then
    Peer.Update(self)
    if self.Pinging then
      if love.timer.getTime() > self.Pinging.time + 5 then
        self.Pinging = nil
        print("no response from server")
      end
    end
  end  
end

function Client:HandleData() --TODO MOVE STUFF FROM PEER TO CLEITN / SERVERERE
  if not from then
    from = self.server.ip
    port = self.server.port
  end
  Peer.HandleData(self)
end

function Client:Debug() end

return Client