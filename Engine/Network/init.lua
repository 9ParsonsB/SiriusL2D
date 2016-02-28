Network = {
  Client = require "Engine/Network/client",
  Server = require "Engine/Network/server",
  NetPeer = require "Engine/Network/netpeer",
  --Peer = require "Engine/Network/peer"
}

function Network.Update(dt)
  if Network.Peer then Network.Peer:Update(dt) end
end

function Network.Draw()
  if Network.Peer then Network.Peer:Draw() end
end