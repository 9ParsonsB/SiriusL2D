
local style = gui.style
style.TEXT = {64, 245, 230}

function menu(dt)
	if gui.begin("home", 362, 200, 300, 40) then
		if gui.button("Play") then ge.play("game") end
		if gui.button("Testing") then gui.play("testing") end
		if gui.button("Settings") then gui.play("settings") end
		if gui.button("Quit") then ge.quit() end
	end

	if gui.begin("testing", 362, 200, 300, 40) then
		gui.label("test1", "center")
		gui.label("test2", "center")
		gui.label("test3", "center")
		if gui.button("Back") then gui.play("home") end
		if ge.pressed("escape") then gui.play("home") end
	end

	if gui.begin("settings", 362, 200, 300, 40) then
		if gui.button("Setting 1") then print("setting 1") end
		if gui.button("Setting 2") then print("setting 2") end
		if gui.button("Setting 3") then print("setting 3") end
		if gui.button("Back") then gui.play("home") end
		if ge.pressed("escape") then gui.play("home") end
	end
end