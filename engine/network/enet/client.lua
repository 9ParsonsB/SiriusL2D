local Peer = require "Engine/Network/peer"
local Client = class("Client", Peer)

local socket = require "socket"

--Connect to server
function Client:Start(address, port)
  ip = socket.dns.toip(address) or address
  self.Host = enet.host_create()
  self.Server = self.Host:connect(ip .. ":" .. port)
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