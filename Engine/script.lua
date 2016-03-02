Script = {
  Files = {}
}

function LoadScript(filePath)
  --Return script
  if Script.Files[filePath] then return Script.Files[filePath] end

  --Load script
  local chunk = love.filesystem.load(filePath .. ".lua")
  Script.Files[filePath] = chunk

  return chunk
end