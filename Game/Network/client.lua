function Engine.Client:Start()
  print("starting client... Connecting...")
  self:Connect('151.229.227.194',7253)
  self.Running = true
end

function Engine.Client:HandleData(data,from,port) 
  self.Super.HandleData(self,data,from,port)
  if self.server.connected then
    if from == self.server.ip then -- recieved data from authority!
      print("OUR ALMIGHTY LORD TOLD US SOMETHING")
    end -- received data from someone else -- TODO: check this with list of client IP's from server 
  end
end