Class("Ship", Entity)

function Ship:Create()
  self.Rooms = {}
end

function Ship:AddRoom(room)
  table.insert(self.Rooms, room)
end