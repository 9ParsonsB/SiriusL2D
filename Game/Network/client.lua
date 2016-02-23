function Engine.Client:Start()
  if self:Connect('siriusgame.ddns.net',7253) then
    self.Running = true
    print("Connecting to server")
    self.udp:send("Are you still there?")
  end
end

function Engine.Client:HandleData(data,from,port) 
  self.Super.HandleData(self)
  if self.P2P then
    if from == self.udp:getsockname() then -- recieved data from authority!
      print("OUR ALMIGHTY LORD TOLD US SOMETHING")
    else -- received data from someone else -- TODO: check this with list of client IP's from server
      
    end
  end
  
end