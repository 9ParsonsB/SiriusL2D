local server = require "Engine/Network/server"

intserver = new Class("intserver")

function intserver:init()
  -- Start the intergrated server
  server:Create()
  server:Update()
end
