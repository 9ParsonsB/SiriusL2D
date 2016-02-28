local Peer = require "Engine/Network/peer"
local Client = Class("Client", Peer)

--Connect to server
function Client:Start(ip)
  self.Host = enet.host_create()
  self.Server = self.Host:connect(ip or "localhost:7253")
  self.Running = true
end

--Handle client events
function Client:HandleEvent(event, dt)
  if event.type == "receive" then
    print("Got message: ", event.data, tostring(event.peer))
    event.peer:send("ping")
  elseif event.type == "connect" then
    print(tostring(event.peer) .. " connected.")
    event.peer:send("ping")
  elseif event.type == "disconnect" then
    print(tostring(event.peer) .. " disconnected.")
  end
end
return Client