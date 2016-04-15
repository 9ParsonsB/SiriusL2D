Input = {
  Binds = {},
}

function Input.Bind(name, value)
  Input.Binds[name] = value
end

function Input.Down(value)
  value = Input.Binds[value] or value
  if type(value) == "number" then return love.mouse.isDown(value) end
  return love.keyboard.isDown(value)
end

function Input.Up(value)
  return not Input.Down(value)
end