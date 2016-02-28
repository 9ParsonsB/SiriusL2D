Script = {
  Envs = {}
}

function Script.Load(filePath, env)
  --File enviroment
  local env = env or setmetatable({}, {__index=_G})
  
  --Store last enviroment and set current enviroment
  if Script.Env then table.insert(Script.Envs, Script.Env) end
  Script.Env = env

  --Load file
  local chunk = love.filesystem.load(filePath .. ".lua")
  setfenv(chunk, env)
  local result = chunk()

  --Set current enviroment to previous enviroment
  Script.Env = Script.Envs[#Script.Envs]
  table.remove(Script.Envs, #Script.Envs)

  return result
end