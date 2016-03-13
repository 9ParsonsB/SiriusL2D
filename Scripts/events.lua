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