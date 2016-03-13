Class("Event", Entity)

Event.X = 300
Event.Y = 200

Event.Description = "Insert event description here..."
Event.Option1 = nil
Event.Option2 = nil
Event.Option3 = nil

function Event:Create()
  Scene.Add(self)
end

function Event:Ui()
  Ui.Label(self.Description, self.X, self.Y, 200, 100)
  
  --Option 1
  local height = Ui.GetTextHeight(self.Description, 200)
  if self.Option1 and Ui.Button(self.Option1, self.X, self.Y + height + 10, 400, 20).Pressed then
  	self:OnOption1()
  end

  --Option 2
  local height = height + Ui.GetTextHeight(self.Option1, 200)
  if self.Option2 and Ui.Button(self.Option2, self.X, self.Y + height + 10, 400, 20).Pressed then
  	self:OnOption2()
  end

  --Option 3
  local height = height + Ui.GetTextHeight(self.Option1, 200)
  if self.Option3 and Ui.Button(self.Option3, self.X, self.Y + height + 10, 400, 20).Pressed then
  	self:OnOption3()
  end
end

--Callbacks
function Event:OnOption1() end
function Event:OnOption2() end
function Event:OnOption3() end

--Displays description with continue option
Class("Result", Event)

Result.Option1 = "Continue"

function Result:Create(description)
  self.Description = description
  Event.Create(self)
end

function Result:OnOption1()
  print("Continue...")
  Scene.Remove(self)
end

--Test event
Class("GiantSpider", Event)

GiantSpider.Description = [[You find a number of ships fleeing from a small space station. 
You hail them, asking what's wrong: "Help! We're being overrun by some sort of giant alien spiders!"]]

GiantSpider.Option1 = "1. Send the crew to help immediately! Giant alien spiders are no joke."
GiantSpider.Option2 = "2. NOPE NOPE NOPE NOPE!!!."

function GiantSpider:Create()
  Event.Create(self)
end

function GiantSpider:OnOption1()
  Result("A crew member dies...")
  Scene.Remove(self)
end

function GiantSpider:OnOption2()
  Result("NONONONONONONO. Your crew frantically turn around the ship and try to get as much distance from these strange creatures as possible.")
  Scene.Remove(self)
end