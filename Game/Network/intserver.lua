local server = require "Engine/Network/server"

intserver = new Class("intserver")

function intserver:Create()
  -- Start the intergrated server
    print "Starting Server. Intergrated."
  server:Start()
  server:Update()
end
