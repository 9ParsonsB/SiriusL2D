function Engine.Client:Start()
  print("starting client... Connecting...")
  self:Connect('127.0.0.1',7253)
  self.Running = true
end

function Engine.Client:Update()
  self.Super.Update(self)
end
  


function Engine.Client:HandleData(packet) 
  self.Super.HandleData(self,packet)
  if self.server.connected then
    if from == self.server.ip then -- recieved data from authority!
      print("OUR ALMIGHTY LORD TOLD US SOMETHING")
    end -- received data from someone else -- TODO: check this with list of client IP's from server 
  end
end