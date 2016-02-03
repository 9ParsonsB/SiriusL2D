local Events = {}
Events.Handlers = {}
Events.HandlerCounts = {}

function Events.Register(trigger, handler)
	if type(handler) ~= "function" then return end

	--Create empty table and count if trigger not registered before
	Events.Handlers[trigger] = Events.Handlers[trigger] or {}
	Events.HandlerCounts[trigger] = Events.HandlerCounts[trigger] or 0

	--Store handler
	Events.Handlers[trigger][Events.HandlerCounts[trigger]] = handler
	Events.HandlerCounts[trigger] = Events.HandlerCounts[trigger] + 1
end

function Events.Fire(trigger, ...)
	if not Events.Handlers[trigger] then return end
	for k, v in pairs(Events.Handlers[trigger]) do
		v(...)
	end
end
return Events