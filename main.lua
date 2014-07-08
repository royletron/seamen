--love.filesystem.load("perlin.lua")()
love.filesystem.setIdentity("royletron")

-- require('strict')

fpsGraph = require "hump.FPSGraph"
World = require 'world.world'
Player = require 'entities.player'
Gamestate = require "hump.gamestate"
InfoPanel = require "entities.info_panel"


impassable = -1
water = 0
stone = 1
beach = 2
dirt = 3
town = 4
treasure = 5

supplies = {{name = 'Bread', min=2, max=10, minnum=30, maxnum=90},
            {name = 'Grog', min=2, max=15, minnum=40, maxnum=90},
            {name = 'Wenches', min=20, max=80, minnum=10, maxnum=35},
            {name = 'Gold', min=30, max=90, minnum=20, maxnum=30},
            {name = 'Sapphires', min=80, max=200, minnum=2, maxnum=15}}

VISION = {love.graphics.newImage('vision_1.png'), love.graphics.newImage('vision_2.png')}

DAY_IN_SECONDS = 86400
SECONDS_PER_DAY = 30
DARKEST_NIGHT = 180

world=World(200,200)
player=Player()
info = InfoPanel(400,10)

DEADZONE_X = 18
DEADZONE_Y = 3

char_font = love.graphics.newFont( 'fonts/DejaVuSansMono.ttf', 13 )
info_font = love.graphics.newFont( 'fonts/DejaVuSansMono-Bold.ttf', 23 )

TILE_W = char_font:getWidth(' ')
TILE_H = char_font:getHeight()

label_font = love.graphics.newFont( 'fonts/DejaVuSansMono.ttf', 10 )
animated_label_font = love.graphics.newFont( 'fonts/DejaVuSansMono.ttf', 18)
pirate_font = love.graphics.newFont( 'fonts/pixel_pirate.ttf', 20 )
pirate_font_small = love.graphics.newFont( 'fonts/pixel_pirate.ttf', 15 )

require 'states.worldmap'
require 'states.townview'
require 'states.fight'

testGraph = nil
testGraph2 = nil
shaders = {}

function love.load()
  love.keyboard.setKeyRepeat( true )

  local spawn = world:getSpawnPoint()
  player.position = {x= spawn.x, y=spawn.y}
  player.ship.x, player.ship.y = spawn.x, spawn.y
  player.camera = {x = spawn.x, y = spawn.y}

  Gamestate.registerEvents()
  Gamestate.switch(WorldMapState)

  	-- fps graph
	testGraph = fpsGraph.createGraph(700, 0)
	-- memory graph
	testGraph2 = fpsGraph.createGraph(700, 30)

  -- prepend the noise function definition to the effect definition
  shaders.perlin = love.graphics.newShader(love.filesystem.read('shaders/perlin2d.glsl') .. [[
    extern float seed = 1;

    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
    {
        number noise = perlin2d(screen_coords / seed);

        noise += 0.75;

        return vec4(color.rgb, noise);
    }
  ]])

  shaders.uniform_static = love.graphics.newShader([[
    extern float seed = 1;

    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
    {
        float offset = mod(seed, 2);

        float alpha = 0;

        alpha = mod(int(screen_coords.x + offset), 2) == 1 ? mod(int(screen_coords.y + offset), 2) == 0 ? 1 : 0 : 0;

        return vec4(color.rgb, alpha);
    }
  ]])

  shaders.static = love.graphics.newShader([[
    extern float seed = 1;

    float rand(vec2 co)
    {
        float a = 12.9898 + seed;
        float b = 78.233;
        float c = 43758.5453;
        float dt = dot(co.xy ,vec2(a,b));
        float sn = mod(dt,3.14);
        return fract(sin(sn) * c);
    }

    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
    {
        float noise = rand(screen_coords);

        return vec4(color.rgb, noise * 2);
    }
  ]])

  shaders.blur = love.graphics.newShader[[
    extern number radius;
    extern vec2 imageSize;

    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
    {
      vec4 newcolor = vec4(0);
      vec2 st;

      for (float x = -radius; x <= radius; x++) {
        for (float y = -radius; y <= radius; y++) {
          screen_coords.xy = vec2(x, y) / imageSize;
          newcolor += Texel(texture, texture_coords + screen_coords);
        }
      }
      newcolor /= ((2.0 * radius + 1.0) * (2.0 * radius + 1.0));
      return newcolor * color;
    }
  ]]
end

function love.draw(dt)
  love.graphics.setFont(pirate_font);
  love.graphics.setColor(251,184,41,255)
  love.graphics.print('Sea-Men',7, 7)
  love.graphics.setFont(pirate_font_small);
  love.graphics.print('men of the sea!',149, 14)
  info:draw(dt)

  fpsGraph.drawGraphs({testGraph, testGraph2})
end

function love.update(dt)
  fpsGraph.updateFPS(testGraph, dt)
	fpsGraph.updateMem(testGraph2, dt)
end

function love.keypressed(key, u)
   --Debug
   if key == "lctrl" then --set to whatever key you want to use
      debug.debug()
   end
end



--function love.draw()
--  if showPerlin == 1 then plot2D(terrain.perlin)
--  else
--    love.graphics.setColor(50,169,167, 255)
--    love.graphics.rectangle("fill", -1, -1, love.graphics.getWidth()+2, love.graphics.getHeight()+2)
--    drawTerrain(terrain)
--  end
--end
--
--function love.keypressed(k, u)
--  if k == "r" then
--    terrain = makeTerrain()
--  elseif k == "p" then
--    showPerlin = 1 - showPerlin
--  elseif k == "escape" then
--    love.event.push("q")
--  end
--end
--
--function love.keyreleased(k)
--
--end
--

--
--function plot1D(values)
--  love.graphics.line(0, love.graphics.getHeight()/2 - 200, love.graphics.getWidth(), love.graphics.getHeight()/2 - 200)
--  love.graphics.line(0, love.graphics.getHeight()/2 + 200, love.graphics.getWidth(), love.graphics.getHeight()/2 + 200)
--  for i = 1, #values - 1 do
--    love.graphics.line((i-1)/(#values-1)*love.graphics.getWidth(), love.graphics.getHeight()/2 - values[i] * 400, (i)/(#values-1)*love.graphics.getWidth(), love.graphics.getHeight()/2 - values[i+1] * 400)
--  end
--end
--
--function plot2D(values)
--  for r = 1, #values do
--    for c = 1, #(values[1]) do
--      love.graphics.setColor(128 + 40 * values[r][c], 128 + 40 * values[r][c], 128 + 40 * values[r][c], 255)
--      love.graphics.rectangle("fill", (c-1)/(#(values[1]))*love.graphics.getWidth(), (r-1)/(#values)*love.graphics.getHeight(), love.graphics.getWidth()/#(values[1]), love.graphics.getHeight()/#values)
--    end
--  end
--end
--
--function makeTerrain(seed)
--  terrain = {}
--  if seed == nil then seed = os.time() end
--  terrain.seed = seed
--  terrain.perlin = perlin2D(seed, 512, 384, 0.55, 7, 4.5)
--  terrain.value = {}
--  for r = 1, #terrain.perlin do
--    terrain.value[r] = {}
--    dirtMargin = (384-r) * 0.01
--    for c = 1, #(terrain.perlin[r]) do
--      value = terrain.perlin[r][c]
--      if value > 0.05 then terrain.value[r][c] = air
--      elseif value > 4.5 - dirtMargin or value < -1 then terrain.value[r][c] = stone
--      elseif value < -0.3 then terrain.value[r][c] = dirt
--      else terrain.value[r][c] = beach
--      end
--    end
--  end
--  return terrain
--end
--
--function drawTerrain(terrain)
--  for r = 1, #terrain.value do
--    for c = 1, #(terrain.value[1]) do
--      if terrain.value[r][c] ~= air then
--        if terrain.value[r][c] == stone then love.graphics.setColor(216,90,16, 255) end
--        if terrain.value[r][c] == beach then love.graphics.setColor(240,209,56, 255) end
--        if terrain.value[r][c] == dirt then love.graphics.setColor(191,204,39, 255) end
--        love.graphics.rectangle("fill", (c-1)/(#(terrain.value[1]))*love.graphics.getWidth(), (r-1)/(#terrain.value)*love.graphics.getHeight(), love.graphics.getWidth()/#(terrain.value[1]), love.graphics.getHeight()/#terrain.value)
--      end
--    end
--  end
--end
--
--
