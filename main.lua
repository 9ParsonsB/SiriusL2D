require "core"
require "data"

-- Who are you, and what do you want?
-- Best of luck to you old friend, El Psy Kongroo
-- game(main+data)

-- flocking
-- weapons/abilities
-- projectiles/lasers

function ge.load(arg)
  scene = ge.Scene("sirius", 1024, 768)
  unit1 = ge.Texture("res/unit1.png")
  unit2 = ge.Texture("res/unit2.png")
  sound = ge.Sound("res/always in this place.mp3")
  camera = ge.Camera(0, 0)

  -- nebula shader(clouds)
  -- use perlin noise to mix with texture
  local perlin = ge.read("res/classicnoise2D.glsl")
  local source = ge.read("res/nebula.glsl")
  cloud = ge.Shader(perlin .. source)
  cloud:send("scale", (math.random() * 2 + 1) / scene.width)
  cloud:send("uColor", {0.7, 0, 1})
  cloud:send("density", math.random() * 0.05)
  cloud:send("falloff", math.random() * 2.0 + 3.0)
  cloud:send("offset", {math.random() * 100, math.random() * 100})

  -- nebula texture(stars)
  -- static so generated here
  local map = ge.ImageData(1024, 768)
  local density, brightness = 0.02, 0.125
  local count = map:getWidth() * map:getHeight() * density
  for i=0,count do
    local x = math.floor(math.random() * map:getWidth())
    local y = math.floor(math.random() * map:getHeight())
    local c = 255 * math.log(1 - math.random()) * -brightness
    map:setPixel(x, y, c, c, c, 255)
  end
  stars = ge.Texture(map)

  -- test units
  units = ge.List()
  local w, h = unit1:getWidth() + 20, unit1:getHeight() + 20
  for y=0,1 do
    local x=0
    -- for x=0,10 do
      units:add(data.unit.scout, 150 + (x * w), 150 + (y * h), 0)
    -- end
  end
  units[1].velocity = Vec(10, 0)
  units[2].velocity = Vec(20, 20)
  rect = ge.Node(nil, 0, 0, 0)
end

function ge.update(dt)
  -- camera:update(dt)

  for k,v in pairs(units) do
    v.position = v.position + v.velocity * dt
    if v.point then 
      ge.moveTowardPoint(v, v.point, 200 * dt) 
      local dir = ge.direction(v, v.point)
      v.r = v.r + math.sin(dir - v.r) * 2 * dt;
    end
  end

  ge.flocking(units)

  if rect.active then
    rect.size = ge.mouse() - rect.position
  end

  if ge.pressed(data.binds.SELECT) then 
    units:select(ge.mouse(), unit1)
    rect.position = ge.mouse()
    rect.size = Vec(0, 0)
    rect.active = true
  end

  if ge.released(data.binds.SELECT) then
    units:select(rect, unit1)
    rect.active = false
  end

  if ge.pressed(data.binds.COMMAND) then
    for k,v in pairs(units) do
      if v.selected then v.point = ge.mouse() end
    end
  end
end

function ge.draw()
  ge.bind(cloud, camera)
  ge.render(stars)
  ge.bind(nil, nil)

  local w, h = unit1:getDimensions()
  for k,v in pairs(units) do
    ge.push(v)
    ge.render(unit1, 0, 0, v.r, 1, 1, w / 2, h / 2)
    if v.selected then
      ge.rectangle("line", -w / 2, -h / 2, w, h)
    end
  end

  if rect.active then
    ge.push(rect)
    ge.rectangle("line", 0, 0, rect.size.x, rect.size.y)
  end
end
