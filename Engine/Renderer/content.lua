local Content = {
  Directory = "Content/",  
  Textures = {},
  Animations = {},
}

function Content.LoadTexture(filePath)
  if Content.Textures[filePath] then return Content.Textures[filePath] end
  
  local texture = love.graphics.newImage(Content.Directory .. filePath)  
  Content.Textures[filePath] = texture

  return texture
end

function Content.LoadAnimation(filePath)
  if Content.Animations[filePath] then return Content.Animations[filePath] end

  --Animation enviroment
  local animation = setmetatable({States={}, Transitions = {}}, {__index = _G})

  function animation.AddFrame(state, x, y, width, height)
    animation[state] = animation[state] or {}
    table.insert(animation[state], {X = x, Y = y, Width = width, Height = height})
  end

  function animation.AddTransition(state, nextState)
    animation.Transitions[state] = nextState
  end

  --Load animation
  local chunk = love.filesystem.load(Content.Directory .. "Animations/" .. filePath .. ".lua")
  setfenv(chunk, animation)
  chunk()
  Content.Animations[filePath] = animation

  return animation
end

--[[function Content.LoadScript(filePath)
  local chunk = love.filesystem.load(Script.Dir .. filePath .. ".lua")
  setfenv(chunk, Script.Env)
  chunk()

  ModTimes[filePath] = love.filesystem.getLastModified(Script.Dir .. filePath .. ".lua")

  return env
end--]]
return Content