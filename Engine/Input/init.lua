Input = {
  KeyBinds = {},
  ButtonBinds = {}
}

function Input.BindKey(name, key)
  KeyBinds[name] = KeyBinds[name] or {}
  table.insert(KeyBinds[name], key)
end

function Input.BindButton(name, button)
  ButtonBinds[name] = ButtonBinds[name] or {}
  table.insert(ButtonBinds[name], button)
end

function Input.BindDown(name)
  for k,v in pairs(Input.KeyBinds) do
  	if Input.KeyDown(v) then return true end
  end
  for k,v in pairs(Input.ButtonBinds) do
  	if Input.ButtonDown(v) then return true end
  end
  return false
end

function Input.BindUp(name)
  for k,v in pairs(Input.KeyBinds) do
  	if Input.KeyUp(v) then return true end
  end
  for k,v in pairs(Input.ButtonBinds) do
  	if Input.ButtonUp(v) then return true end
  end
  return false
end

function Input.KeyDown(key)
  return love.keyboard.isDown(key)
end

function Input.KeyUp(key)
  return not love.keyboard.isDown(key)
end

function Input.ButtonDown(button)
  return love.mouse.isDown(button)
end

function Input.ButtonUp(button)
  return not love.mouse.isDown(button)
end