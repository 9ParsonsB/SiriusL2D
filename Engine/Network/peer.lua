local socket = require("socket")
local Peer = Class('Peer')

function Peer:Create(name)
  self.port = 7253
  self.udp = socket.udp()
  self.udp:settimeout(self.timeout)
  self.peername = name -- TODO change to steamID
  self.P2P = false
  self.server = {}
  self.timeout = 0
end

function Peer:Connect(ip,port)
  if self.pinging then
    error("Connecting too quickly!")
  end
  
  if self.udp:setpeername(ip,port) then
    self.udp:sendto("ping",ip,port)
    print("waiting for pong for 5 seconds")
    self.pinging = {ip = ip, port = port, time = love.timer.getTime()}
  end
end

function Peer:SendToServer(data)
  if self.P2P then
    if self.Connected then
      self.udp:sendto(data, self.server.ip, self.server.port)
    end
  else
    if self.udp:send(data) then
      return true
    end
    return
  end
end

function Peer:Discover()
  if self.udp:setoption('broadcast',true) then
    self.multicast = true
    local success, msg = self.udp:sendto("Is anyone there?","255.255.255.255",self.port)
    if not success then
      --failed
      print("failed to broadcast: "..msg)
    end
  end
end

function Peer:Update()
  if self.Connected and self.udp:getsockname() then
    repeat -- do this once
      print(self.udp:getsockname())
      data,from,port = self.udp:receive() -- from can also be an error message if port is nil
      if data then
        self.HandleData(data,from,port)
      else
        print("nothing to receive")
      end
    until not data -- and continue until there is no more data TODO: change this so that it will not take up more than X or just override
  end
  if self.pinging then
      if love.timer.getTime() > self.pinging.time + 5 then
        self.pinging = nil
        print("no response from server")
      end
    end  
  
end

function Peer:HandleData(data,from,port)
  print(from..": "..data)
  if port then 
    

    if data == "ping" then
      self.udp:sendto("pong",from,port)
    elseif data == "pong"  and self.pinging and from == self.pinging.ip and port == self.pining.port then 
      self.server.ip = ip
      self.server.port = port
      self.Connected = true
    end

  
    
    self.udp:sendto("Please Override") --  just so they know we got the message
  elseif from then -- if there was no port due to a network message being sent.
    print("error: " ..from ) -- print the message
  elseif data then
    print("error: " ..data)
  end
end
return Peer