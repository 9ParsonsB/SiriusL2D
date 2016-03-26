require "enet"

local Peer = Class("Peer")

Peer.Running = false

function Peer:Update(dt)
  if self.Running then 
    local event = self.Host:service(100)
    while event do
      self:HandleEvent(event, dt)
      event = self.Host:service()
    end
  end
end

function Peer:HandleEvent(event, dt) end
function Peer:Send(msg) end

--Callbacks
function Peer:OnHandleData(data) end

return Peer