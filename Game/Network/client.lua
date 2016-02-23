local Client = require "Engine/Network/client"
local client = Class("client", Client)

function client:Start()
 
  if self:Connect('siriusgame.ddns.net',7253) then
    self.Running = true
    print("Connecting to server")
    self.udp:send("Are you still there?")
  end
end

