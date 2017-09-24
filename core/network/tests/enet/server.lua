local Peer = require "core/network/peer"
local Server = class("server", Peer)

local socket = require "socket"

--Start hosting the server
function Server:init(port)
  self.Host = enet.host_create("localhost:" .. port)
  self.Running = true
end

--Handle server events
function Server:HandleEvent(event, dt)
  if event.type == "receive" then
    print("Got message: ", event.data, event.peer)
    event.peer:send("pong")
  elseif event.type == "connect" then
    print(tostring(event.peer) .. " connected.")
  elseif event.type == "disconnect" then
    print(tostring(event.peer) .. " disconnected.")
  end
end

--Message sending
function Server:SendToAll(msg) 
  if self.Running then self.Host:broadcast(msg, 0, "unsequenced") end
end
return Server