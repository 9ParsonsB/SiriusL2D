local Peer = Class('Peer')
Peer.socket = require("socket")
require('Engine/Network/dump')
Peer.udp = Peer.socket.udp()

function Peer:Create(name)
  self.netPeers = {}
  self.Running = true
  self.port = 7253
  self.udp = Peer.udp
  self.dns = self.socket.dns  
  self.udp:settimeout(self.timeout)
  self.peername = name -- TODO change to steamID
  self.P2P = false
  self.timeout = 0
  self.timeouttime = 99999999
  self.pingpollrate = 5
end

function Peer:getNetPeerFromIP(ip)
  for i,v in ipairs(self.netPeers) do
    if v.ip == ip then
      return v, i
    end
  end
end

function Peer:getNetPeerFromPacket(packet)
  for i,v in ipairs(self.netPeers) do
    if v.ip == packet.sender then
      return v, i
    end
  end
end

function Peer:Connect(addr,port)
  local ip = self.dns.toip(addr)
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

function Peer:Discover()
  if self.udp:setoption('broadcast',true) then
    self.multicast = true
    local success, msg = self.udp:sendto("disc","255.255.255.255",self.port)
    if not success then
      --failed
      print("failed to broadcast: "..msg)
    end
  end
  send:setoption( "broadcast", false ) 
end

function Peer:Update()
  local packet
  self.udp:settimeout(0)

    repeat -- do this once
      local ip_or_data, msg_or_ip, port_or_nil = self.udp:receivefrom()-- from can also be an error message if port is nil
      if port_or_nil ~= nil then -- if the port is not nil then
        local temptime = self.socket.gettime()
        if ip_or_data then -- if ip_or_data then and port is not nill then ip_or_data is data
          
          --print("ip_or_data: " ..ip_or_data)
          packet = self.ConvertPacketData(ip_or_data)
          packet.sender = msg_or_ip
          
          if port_or_nil then
            packet.port = port_or_nil
          end
          
          if packet then
            --if packet.isvalid then -- if this is a valid packet (has the isvalid atribute). only works if the deserlization worked
            
              packet.receivedtime = temptime-- get the time at which we recieved the packet (used later, very useful)
              
              if packet.data then
                self:HandleData(packet)
              end
              
              if packet.sender == msg_or_ip then
                if packet.port ~= port_or_nil then
                  print("Packet port and received port not the same!!")
                end
              else
                print("Packet sender and connection sender not the same!!")
              end
            --end
          else
            error("packet resolved nil")
          end
        end
        
        
      else -- if port is nil -- TODO: show network messages
        if ip_or_data and msg_or_ip then
          print("port is nil")
          print("data/ip: ".. ip_or_data)
          print("msg/ip: " ..msg_or_ip)
          from = ip_or_data
        end
      end

    until not ip_or_data-- and continue until there is no more data or messages TODO: change this so that it will not take up more than X or just override

  -- check if peers need to have their ping updated
  if #self.netPeers > 0 then -- if we have more than 0 peers then
    for i,v in ipairs(self.netPeers) do -- for each peer
      if v.connected then -- if they are connected
        if self.socket.gettime() > v.lastattemptedpingtime + 2 then
          if v.lastpingtime + self.pingpollrate < self.socket.gettime()  then -- if the last time we pinged them plus the poll rate is smaller than the current time
            self:Ping(v.ip,v.port)
          elseif v.lastpingtime + self.timeouttime < self.socket.gettime()  then -- if the last atempted ping time plus the timeout duration is smaller than the current time (meaning we have waited the timeout time)
            print("peer:".. v.name ..". was last pinged: ".. (self.socket.gettime() - v.lastattemptedpingtime):tostring() .. " secs ago, disconnecting. timed out.")
            v.connected = false -- disconnect them
          end
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
    end
  end
end

function Peer:HandleDiscovery(packet) -- this method is designed to be overriden
end

function Peer:HandleData(packet)  -- TODO: BUG: THE SERVER ACCEPTS THE CLIENT CONNECTION BUT THE CLIENT DOES NOT RECIEVE SYN TODO:SEND SYN
  local sdata = packet.data
  print("peer:handledata")
  if not sdata then print("data in nil") end
  
    
    self:updateNetClientPing(packet) -- calculate the ping from the packet sent / received times and update the netclient with the same address
    
    if sdata == "ping" then
      self:handlePing(packet)
    end
    
    if sdata == "pong" then
      self:handlePong(packet)
    end
    
    if self.isDiscoverable then
      if sdata == "disc" then
        self:HandleDiscovery(packet)
      end
    end
    
    if self.Connecting then -- a
      print("maybe this packet")
      if sdata == "ack" then
        self:handleConnectionResponse(packet) 
      end
    end
    
    if sdata == "conn" then
      self:handleConnectionRequest(packet)
    end
    
    if packet.sender then
      print(packet.sender .. ": "..sdata)
    end
end

function Peer:handlePong(packet)
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

function Peer:handleConnectionActive(packet)
  print ("recieved connack from :" .. packet.sender)
  local v, i = self:getNetPeerFromPacket(packet)
  if v then
    self.netPeer[i].connected = true
    print(v.ip .. " connection status set to true")
  else
    print("client that sent connack is not in netPeer table, ignoring.")
  end
end

function Peer:handleConnectionResponse(packet)
  print("received ack from: " .. packet.sender)
  --if self.Connnecting then
    if self.Connecting.ip == packet.sender then
      --if self.Connecting.port == packet.port then
        print("inserting: " .. packet.sender .. " into peer table with active connection")
        table.insert(self.netPeers, Network.NetPeer(packet,true))
        self:SendPacket(self:Packet("connack"),packet.sender)
      --else print("packet.port and self.Connecting.port are not the same!") end
    else print("packet.sender and self.Connecting.ip are not the same!") end
  --else print("handleConnectionResponse called but self.Connecting = nil")
end

function Peer:handleConnectionRequest(packet)
  print("recieved conn from: " .. packet.sender)
  local opacket = self:Packet("ack")
  self:SendPacket(opacket,packet.sender)
  table.insert(self.netPeers, Network.NetPeer(packet,false)) -- set the connection status to false until we receive connsyn
  self:updateNetClientPing(packet) -- update the clients ping with the same packet
end

function Peer:Ping(ip,port)
  peer, i = self:getNetPeerFromIP(ip)
  if peer then
    self.netPeers[i].lastattemptedpingtime = self.socket.gettime()
  end

  local packet = self:Packet("ping")
  packet.debug = "sent from ping"
  self:SendPacket(packet, ip)
end

function Peer:Packet(data)
  local Packet = Class("Packet")
  Packet.sender = self.peername
  Packet.sendertype = self.Name
  Packet.port = Peer.port or 7253
  Packet.data = data
  if data then Packet.isvalid = true end
  return Packet
end

function Peer:SendPacket(packet,recipient, port)  
  if recipient then recipient = self.socket.dns.toip(recipient) or recipient end
  if packet.recipient then packet.recipient = self.socket.dns.toip(packet.recipient) or packet.recipient end
  packet.recipient = packet.recipient or recipient  -- try and convert the addr to an ip, or just use the addr
  packet.port = packet.port or port or self.port
  
  print("sending data to :" .. packet.recipient)
  print("I am: " .. self.Name)
  
  if packet.debug then print(packet.debug) end
  
  packet.senttime = self.socket.gettime()
  sdata = DataDumper(packet)
  self.udp:sendto(sdata,packet.recipient, packet.port)
  return 1
end

function Peer.ConvertPacketData(spacket)
  --print('packet: ' ..spacket)
  local result = loadstring(spacket) () 
  local isvalid
  if result.isvalid then isvalid = "true" else isvalid = "false" end
  print("packed isvalid?: " .. isvalid )
  return result
end

function Peer:updateNetClientPing(packet)
  netpeer, index = self:getNetPeerFromPacket(packet)
  if netpeer then
    self.netPeers[index].ping = packet.receivedtime - packet.senttime
    self.netPeers[index].lastpingtime = selp.socket.gettime() 
    return netpeer
  end
end

function Peer:pingNetPeer(peer)
  self:Ping(peer.ip,peer.port)
end

return Peer