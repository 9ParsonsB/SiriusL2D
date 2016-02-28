local Server = require "Engine/Network/server"
local Client = require "Engine/Network/client"

Network = {}

Network.Client = Client()
Network.Server = Server()

function Network.Update(dt)
  Network.Client:Update(dt)
  Network.Server:Update(dt)
end