local Server = require "Engine/Network/server"
local Client = require "Engine/Network/client"

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
  	print("ID duplicated. This should never happen!")
  	uuid = math.random(5.6e300)
  end

  table.insert(UUIDs, uuid)

  return uuid
end

--[[local env = {}
local chunk = loadstring("print('UNSAFE')")
setfenv(chunk, {})
chunk()--]]