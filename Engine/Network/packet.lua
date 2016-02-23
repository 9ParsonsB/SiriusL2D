local Packet = Class('Peer')

function Packet:Create(Peer,Data)
  if ~Peer.Name == "Peer" then
    return
  end
  return {version = -1, data = Data, from = Peer.peername}
end

