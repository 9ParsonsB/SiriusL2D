local socket = require "socket"
local address, port = "siriusgame.ddns.net", 7253 --TODO: make configurable

local updaterate = 0.1
local t

local Peer = require "Engine/Network/peer"
local Client = Class("Client", Peer)

function Client:Create(peername)
  Peer.Create(self,peername)
end

function Client:Connect(addr,port)
  local ip
  ip = self.dns.toip(addr)
  if not ip then
    ip = addr
    print("IP returned nil, attempting direct addr connect.")
  end
  
  if self.Connecting then
    error("Connecting too quickly!")
  end
  
  local p,i = self:getNetPeerFromIP(ip)
  if not p.connected and not self.Connecting then
    print("connecting to: " .. ip .. ":"..port)
    self.udp:setpeername(ip,port)
    self.server = Network.NetPeer({},false)
    self.server.ip = ip
    self.server.port = port
    local packet = Peer:Packet("conn")
    packet.debug = "sent from connect 2"
    self:SendPacket(packet,ip)
    self.Connecting = {ip = ip, port = port, time = self.socket.gettime()}
    print("waiting for ack for 5 seconds")
  else
    if p.connected then
      error("DONT TRY AND CONNECT TO AN ALREADY ACTIVE CONNECTION, DAMMIT!")
    end
  end
end

function Peer:SendPacket(packet,ip,port)
  packet.recipient = packet.recipient or self.socket.dns.toip(packet.recipient) or self.socket.dns.toip(ip) or ip  -- try and convert the addr to an ip, or just use the addr
  packet.port = packet.port or port
  
  if not ip then 
    print("Client: sending data to server")
  else
    print("Client: sending data to :" .. packet.recipient)
  end

  
  if packet.debug then print(packet.debug) end
  
  packet.senttime = self.socket.gettime()
  
  sdata = DataDumper(packet)
  if ip or port then
    self.udp:sendto(sdata,packet.recipient,packet.port)
  else
    self.udp:send(sdata)
  end
  return 1
end

function Peer:handlePing(ipacket)
  packet = self:Packet("pong")
  packet.debug = "sent from handlePing"
  packet.port = ipacket.port
  self:SendPacket(packet,ipacket.sender)
end

function Peer:Ping(ip,port)
  if ip then
    peer, i = self:getNetPeerFromIP(ip)
    if peer then
      self.netPeers[i].lastattemptedpingtime = self.socket.gettime()
    end
  end

  local packet = self:Packet("ping")
  packet.debug = "sent from ping"
  
  if not ip and not port then 
    self:SendPacket(packet)
  else
    self:SendPacket(packet, ip)
  end
end


function Client:Start() end

function Client:Update()
  local packet
  self.udp:settimeout(0)
  if self.Connecting or self.server.connected then
    repeat -- do this once
      local nil_or_data, msg_or_nil = self.udp:receive()-- receives data and nil if actual data sent, otherwise, sends nil and a message (allways 'timeout')
      if nil_or_data ~= nil then -- if the port is not nil then
        local temptime = self.socket.gettime()
        if nil_or_data then -- if ip_or_data then and port is not nill then ip_or_data is data
          
          --print("ip_or_data: " ..ip_or_data)
          packet = self.ConvertPacketData(nil_or_data)
          
          if packet then
            --if packet.isvalid then -- if this is a valid packet (has the isvalid atribute). only works if the deserlization worked
            
              packet.receivedtime = temptime-- get the time at which we recieved the packet (used later, very useful)
              
              if packet.data then
                self:HandleData(packet)
              end
              
              if packet.sender == msg_or_nil then
                if msg_or_nil == "timeout" then 
                  print ("udp socket: server timmed out")
                  self.server = nil
                  self.Connecting = nil
              else
                print("Packet sender and connection sender not the same!!")
              end
            --end
          else
            error("packet resolved nil")
          end
        end
        
        
      else -- if port is nil -- TODO: show network messages
        if nil_or_data and msg_or_nil then
          print("port is nil")
          print("data/ip: ".. nil_or_data)
          print("msg/ip: " ..msg_or_nil)
          from = nil_or_data
        end
      end

    until not nil_or_data-- and continue until there is no more data or messages TODO: change this so that it will not take up more than X or just override
  end
  -- check if peers need to have their ping updated
  if self.server then -- if we have more than 0 peers then
    v = self.server
    if v.connected then -- if they are connected
      if self.socket.gettime() > v.lastattemptedpingtime + 2 then
        if v.lastpingtime + self.pingpollrate < self.socket.gettime()  then -- if the last time we pinged them plus the poll rate is smaller than the current time
          self:pingServer()
        elseif v.lastpingtime + self.timeouttime < self.socket.gettime()  then -- if the last atempted ping time plus the timeout duration is smaller than the current time  (meaning we have waited the timeout time)
          print("Sir, They are not responding to our hails! We last hailed them: ".. (self.socket.gettime() - v.lastattemptedpingtime):tostring() .. " secs ago. Terminating.")
          v.connected = false -- disconnect them
          self.server = nil
        end
      end
    end
  end  
        
  
  if self.Connecting then
    -- debug -- 
    --print( "start: " .. self.Connecting.time .. ". timeout at: " .. (self.Connecting.time + self.timeouttime) .. ". current: " .. self.socket.gettime())
    if self.Connecting.time + self.timeouttime < self.socket.gettime() then -- if it has been timeouttime then presume there is no server (stop looking for ack)
      self.Connecting = nil
      print("no response.")
      if self.server then
        print("presuming that we failed to connect to ther server, i am gonna delete it.")
        self.server = nil
      end
    end
  end
end

function Client:handlePong(packet)
  client = self:updateNetClientPing(packet)
  if client and client.ping then
    return true
  end
end

function Peer:handlePing(ipacket)
  packet = self:Packet("pong")
  packet.debug = "sent from handlePing"
  self:SendPacket(packet,ipacket.sender)
end

function Peer:handleConnectionResponse(packet)
  print("received ack from udp socket / server")
    if self.server then
        print("inserting: " .. packet.sender .. " into peer table with active connection")
        self.server.connected = true
        self:SendPacket(self:Packet("connack"))
    else print("self.server is not set, yet received ack?") end
end

function Peer:updateNetClientPing(packet)
  netpeer, index = self:getNetPeerFromPacket(packet)
  if netpeer then
    self.netPeers[index].ping = packet.receivedtime - packet.senttime
    self.netPeers[index].lastpingtime = selp.socket.gettime() 
    return netpeer
  end
end

function Client:pingServer()
  if self.server then
    self:SendPacket(self:Packet("ping"))
  end
end

function Client:HandleData(packet) --TODO MOVE STUFF FROM PEER TO CLIENT / SERVER
  self.Super.HandleData(self,packet)
end

function Client:Debug() end

return Client