Network = {}

Network.lube

Network.Client = Class("GenericClient", Network.lube.Client)
Network.Server = Class("GenericServer", Network.lube.Server)

-- Lube Client Overrides
 
function Network.Client:Create()
  self.Client:init()
end

function Network.Client:_send(data)
  data = DataDumper(data)
	return self.socket:sendto(data, self.host, self.port)
end

function Network.Client:_receive()
	local data, ip, port = self.socket:receivefrom()
	if ip == self.host and port == self.port then
		local result = loadstring(data)
    setfenv(result,{})
    return result()
	end
	return false, "Unknown remote sent data."
end

-- Lube Server Overrides

function Network.Server:Create()
  self.Server:init()
end

function Network.Server:send(data, clientid)
  data = DataDumper(data)
  
  if clientid then
		local ip, port = clientid:match("^(.-):(%d+)$")
		self.socket:sendto(data, ip, tonumber(port))
	else
		for clientid, _ in pairs(self.clients) do
			local ip, port = clientid:match("^(.-):(%d+)$")
			self.socket:sendto(data, ip, tonumber(port))
		end
	end
end

function Network.Server:receive()
	for sock, _ in pairs(self.clients) do
		local packet = ""
		local data, _, partial = sock:receive(8192)
		while data do
			packet = packet .. data
			data, _, partial = sock:receive(8192)
		end
		if not data and partial then
			packet = packet .. partial
    else
      local result = loadstring(packet)
      setfenv(result,{})
      packet = result()
		end
		if packet ~= "" and packet then
			return packet, sock
		end
	end
	for i, sock in pairs(self._socks) do
		local data = sock:receive()
		if data then
			local hs, conn = data:match("^(.+)([%+%-])\n?$")
			if hs == self.handshake and conn ==  "+" then
				self._socks[i] = nil
				return data, sock
			end
		end
	end
	return nil, "No messages."
end

-- Update client and server if they exist

function Network.Update(dt)
  if Network.lube then
    if Network.Client:update then Network.Client:update(dt) end
    if Network.Server:update then Network.Server:update(dt)
  end
end

function Network.Draw()
  --if Network.Peer then Network.Peer:Draw() end
end