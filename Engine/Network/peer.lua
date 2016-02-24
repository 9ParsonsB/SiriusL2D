local Peer = Class('Peer')
require('Engine/Network/shared')
Peer.socket = require("socket")
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
  self.timeouttime = 20
  self.pingpollrate = 5
end

function Peer:getSelfID()
  if self.peername then
    return ("@".. self.Name .. "@" .. self.peername .."@" .. self.socket.gettime())
  else
    return ("Client@FAILED@")
    --    error("self.peername is not set. Please set self.peername")
  end
end

function Peer:Connect(addr,port)
  name, alias, ip = self.dns.toip(addr)
  if not ip then
    ip = addr
    print("IP returned nil, attempting direct addr connect.")
  end
  
  if self.Connecting then
    error("Connecting too quickly!")
  end
  
  if self.P2P then
    self.udp:sendto("conn" .. self:getSelfID(),ip,port)
    print("waiting for ack for 5 seconds")
    self.Connecting = {ip = ip, port = port, time = love.timer.getTime()}
  end
  
  p,i = self:getNetPeerByIP(ip)
  if not p.connected and not self.Connecting then
    print("connecting to: " .. ip .. ":"..port)
    self.udp:sendto("conn" .. self.getSelfID(self),ip,port)
    print("waiting for ack for 5 seconds")
    self.Connecting = {ip = ip, port = port, time = self.socket.gettime()}
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
  local data
  local port
  local from
  self.udp:settimeout(0)
  if self.Running then
    repeat -- do this once
      local ip_or_data, msg_or_ip, port_or_nil = self.udp:receivefrom()-- from can also be an error message if port is nil
      if port_or_nil ~= nil then -- if the port is not nil then
        if ip_or_data then -- if ip_or_data then and port is not nill then ip_or_data is data
          Packet = ip_or_data
          if Packet.isvalid then
            
            packet.receivedtime = self.socket.gettime() -- get the time at which we recieved the packet (used later, very useful)
            data = Packet.data
            
            if Packet.sender == msg_or_ip then
              if Packet.port ~= port_or_nil then
                print("Packet port and received port not the same!!")
              end
            else
              print("Packet sender and connection sender not the same!!")
            end
            
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
      if data then
        self:HandleData(packet)
      end
    until not ip_or_data-- and continue until there is no more data or messages TODO: change this so that it will not take up more than X or just override
  end
  -- check if peers need to have their ping updated
  if #self.netPeers > 0 then -- if we have more than 0 peers then
    for i,v in ipairs(self.netPeers) do -- for each peer
      if v.connected then -- if they are connected
        if v.lastpingtime + self.pingpollrate < self.socket.gettime()  then -- if the last time we pinged them plus the poll rate is smaller than the current time
          self:Ping(v.ip,v.port)
        elseif v.lastattemptedpingtime + self.timeouttime < self.socket.gettime()  then -- if the last atempted ping time plus the timeout duration is smaller than the current time (meaning we have waited the timeout time)
          print("peer:".. v.name ..". was last pinged: ".. (self.socket.gettime() - v.lastattemptedpingtime):tostring() .. " secs ago, disconnecting. timed out.")
          v.connected = false -- disconnect them
        end
      end
    end
  end  
        
  
  if self.Connecting then
    print( "start: " .. self.Connecting.time .. ". timeout at: " .. (self.Connecting.time + self.timeouttime) .. ". current: " .. self.socket.gettime())
    if self.Connecting.time + self.timeouttime < self.socket.gettime() then -- if it has been timeouttime then presume there is no server (stop looking for ack)
      self.Connecting = nil
      print("no response.")
    end
  end
end

function Peer:HandleDiscovery(data,from,port) -- this method is designed to be overriden
  udp:sendto("resp" + self:getSelfID(),from,port)
end

function Peer:HandleData(packet)  
  local data = packet.data
  if not data then print("data in nil") end
  
  if packet.port and packet.sender and packet.data then 
    
    self:updateNetClientPing(packet) -- calculate the ping from the packet sent / received times and update the netclient with the same address
    
    if data:match("ping") then
      self:handlePing(packet)
      return
    end
    
    if data:match("pong") then
      self:handlePong(packet)
      return
    end
    
    if self.isDiscoverable then
      if data:match("disc") then
        self.HandleDiscovery(data,packet.sender,packet.port)
        return
      end
    end
    
    if self.Connecting then
      if self:handleConnectionResponse(packet) then 
        return
      end
    end -- if we are waiting for a response, then try and handle it, if we do handle it then return as we have nothing else to do with this Packet type.
    
    if data:match("conn") then
      self:sendConnectionConfirmation(data,from,port)
    end
    print(from.. ": "..data)
    elseif from then -- if there was no port due to a network message being sent.
    print("error: " ..from ) -- print the message
  elseif data then
    print("error: " ..data)
  end
end

function Peer:handlePing(packet)
  packet = self:Packet("pong")
  packet:Send(packet.sender)
end

function Peer:updateNetClientPing(packet)
  netpeer, index = self:getNetPeerByIP(form)
  if netpeer then
    self.netPeers[index].ping = packet.receivedtime - packet.senttime
    print("ping updated for " .. netpeer.name)
  end
end

function Peer:handleConnectionResponse(packet)
  local data = packet.data
  local tempdata = data
  if data:match("ack") and packet.sender == self.Connecting.ip and packet.port == self.Connecting.port then 
    data = tempdata
    print("recieved pong from ")
    local split = data:split("@")
    ptype = split[2]
    pname = split[3]
    print("inserting :" ..pname.. ". into peer table.")
    self.udp:sendto("ack")
    table.insert(self.netPeers,Network.NetPeer(ip,port,ptype,name,true))
    self.Connecting = nil
  end
end

function Peer:sendConnectionConfirmation(data,from,port)
  self.udp:sendto("ack" .. self:getSelfID(),from,port)
  local split = data:split("@")
    ptype = split[2]
    pname = split[3]
  table.insert(self.netPeers,Network.NetPeer(from,port,ptype,name,true))
  print("Accepted conneciton from: " .. from)
end

function Peer:Ping(ip,port)
  peer, i = self:getNetPeerByIP(ip)
  if peer then
    self.netPeer[i].lastattemptedpingtime = self.socket.gettime()
  end

  local packet = self:Packet("ping")
  packet:Send(ip)
end

function Peer:Packet(data)
  local Packet = Class("Packet")
  Packet.sender = self.peername
  Packet.sendertype = self.Name
  Packet.port = self.port
  Packet.data = data
  if data then Packet.isvalid = true end
  
  function Packet:Send(recipient)
    Packet.recipient = Peer.socket.dns.toip(recipient) or recipient
    Packet.senttime = Peer.socket.gettime()
    Peer.udp:sendto(table.tostring(Packet),Packet.recipient,Packet.port)
  end
  
  function Packet:getPeer()
    Peer:getNetPeerByIP(self.ip)
  end
  
  return Packet
  
end

function Peer:getNetPeerByIP(ip)
  for i,v in ipairs(self.netPeers) do
    if v.ip == ip then
      return v, i
    end
  end
end

function Peer:pingNetPeer(peer)
  self:Ping(peer.ip,peer.port)
end

return Peer