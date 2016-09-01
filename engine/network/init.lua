local Server = require "engine/network/server"
local Client = require "engine/network/client"

local UUIDs = {}

Network = {
  Client = Client(),
  Server = Server()
}

--Seed random generator
math.randomseed(os.time())

function Network.Update(dt)
  Network.Client:Update(dt)
  Network.Server:Update(dt)
end

function Network.UUID()
  local uuid = math.random(5.6e300)

  while table.contains(UUIDs, uuid) do
    --THIS SHOULD NOT HAPPEN EVER!
  	love.system.openURL("http://hasthelargehadroncolliderdestroyedtheworldyet.com/")
    uuid = math.random(5.6e300)
  end

  table.insert(UUIDs, uuid)

  return uuid
end

--[[local env = {}
local chunk = loadstring("print('UNSAFE')")
setfenv(chunk, {})
chunk()--]]
