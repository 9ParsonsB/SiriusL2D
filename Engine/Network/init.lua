local Server = require "Engine/Network/server"
local Client = require "Engine/Network/client"

local UUIDs = List()

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

  while UUIDs:Contains(uuid) do
  	print("ID already exists")
  	uuid = math.random(5.6e300)
  end

  UUIDs:Add(uuid)

  return uuid
end

--[[local env = {}
local chunk = loadstring("print('UNSAFE')")
setfenv(chunk, {})
chunk()--]]