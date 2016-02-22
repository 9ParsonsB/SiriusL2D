local socket = require "socket"
local address, port = "siriusgame.ddns.net", 7253

local updaterate = 0.1
local t

function Client:Create() --TODO: move to engine
  udp = socket.udp()
  udp:settimeout(0)
end

function Client:Start()
  -- TODO add engine/client/connect (add connecting / d/c)
  udp:setpeername(address,port)
  udp:send("Are you still there?")
end

function Client:Update()
  repeat
    data, msg = udp:receive()
    
    if data then
      print "DATA!!!!"
      print data
    elseif msg -= "timeout" then
      print "Network error: " ..tostring(msg)
    end
end
