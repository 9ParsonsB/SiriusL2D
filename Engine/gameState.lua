require "Engine/class"

--Updates and draws a group of entities
local Screen = Class.New("Screen")

Screen.Entities = {}
Screen.EntityCount = 0
Screen.Active = true
Screen.Visible = true

function Screen:Add(object)
	self.EntityCount = self.EntityCount + 1
	self.Entities[self.EntityCount] = object
	return self.EntityCount
end
function Screen:Remove(object)
	if self.Entities[object.Key] then
		self.Entities[object.Key] = nil
		collectgarbage()
	end
end
function Screen:Update(dt)
	--Update entities
    for k,v in pairs(self.Entities) do
    	v.X = v.X + v.VelX * dt
    	v.Y = v.Y + v.VelY * dt
    	if v.Collider then v:SetVelocity(v.Collider:GetVelocity()) end
    	v:Update(dt) 
    end
end
function Screen:Draw()
	if self.Camera then self.Camera:Set() end

	--Draw entities
	for k, v in pairs(self.Entities) do v:Draw() end

    if self.Camera then self.Camera:Unset() end
end

--Updates and draws a group of screens
local GameState = Class.New("GameState")

GameState.Screens = {}

function GameState:SetScreen(object, screen)
	if self.Screens[screen] then
		self.Screens[screen]:Remove(object)
	else 	
		self.Screens[screen] = Screen()
	end
	object.Key = self.Screens[screen]:Add(object) 
	object.Screen = screen
end
function GameState:Destroy(object)
	self.Screens[object.Screen]:Remove(object)
end
function GameState:SetCamera(camera, screen)
	if self.Screens[screen] then
		self.Screens[screen].Camera = camera
	else 	
		self.Screens[screen] = Screen()
		self.Screens[screen].Camera = camera
	end
end
function GameState:Update(dt)
	for k,v in pairs(self.Screens) do
		if v.Active then v:Update(dt) end
	end
end
function GameState:Draw()
	for k,v in pairs(self.Screens) do
		if v.Visible then v:Draw() end
	end
end
return GameState