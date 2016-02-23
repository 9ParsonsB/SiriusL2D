local socket = require("socket")
local Peer = Class('Peer')

function Peer:Create(name)
  self.udp = socket.udp()
  self.udp:settimeout(0)
  self.peername = name -- TODO change to steamID
  self.P2P = false
end

function Peer:Connect(ip,port)
  self.udp:setpeername(ip,port)
  if self.udp:getsockname() then
    self.Connected = true
    return true
  end
end

function Peer:Discover()
  if self.udp:setoption('broadcast',true) then
    self.multicast = true
    local success, msg = udp:sendto("Is anyone there?","255.255.255.255",7253)
    if not success then
      --failed
      print("failed to broadcast: "..msg)
    end
  end
end

function Peer:Update()
  repeat -- do this once
    data,from,port = self.udp:receivefrom() -- from can also be an error message if port is nil
    if data then
      self.HandleData(data,from,port)
    end
  until not data -- and continue until there is no more data TODO: change this so that it will not take up more than X or just override
end

function Peer:HandleData(data,from,port)
  if port then
      print(from..": "..data)
      udp:sendto("Please Override") --  just so they know we got the message
    elseif from then -- if there was no port due to a network message being sent.
      print("error: " ..from ) -- print the message
    else
      print("error: " ..data)
    end
end
return Peer