--love.filesystem.load("perlin.lua")()
love.filesystem.setIdentity("royletron")

World = require 'world'
Player = require 'entities.player'
Gamestate = require "hump.gamestate"

globals = {
  world=World(200,200), 
  player=Player(),
  TILE_W = 9,
  TILE_H = 15,
  air = 0,
  stone = 1,
  beach = 2,
  dirt = 3,
  town = 4,
  char_font = love.graphics.newFont( 'DejaVuSansMono.ttf', 13 ),
  label_font = love.graphics.newFont( 'DejaVuSansMono.ttf', 10 )
}

require 'states.worldmap'

function love.load()
  love.keyboard.setKeyRepeat( true )
  Gamestate.registerEvents()
  Gamestate.switch(WorldMapState)
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
