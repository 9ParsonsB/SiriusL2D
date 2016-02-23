local socket = require "socket"
local address, port = "siriusgame.ddns.net", 7253 --TODO: make configurable

local updaterate = 0.1
local t
local Client = Class("Client","Peer")

function Client:Create()
  self.udp = socket.udp()
  self.udp:settimeout(0)
end


function Client:Update()
  repeat
    data, msg = udp:receive()
    
    if data then
      print("DATA!!!!")
      print(data)
    elseif msg ~= "timeout" then
      print("Network error: " ..tostring(msg))
    end
  until not data
end
return Client