local client = require "Engine/Network/client"

function client:Start()
  -- TODO add engine/client/connect (add connecting / d/c)
  
  self.udp:setpeername(address,port)
  self.udp:send("Are you still there?")
  self.Running = true
  print("Connecting to server")
end

