require('ascii.ships')
require('ascii.hud')
require('ascii.landlubber')

local AsciiSprite = require('ascii.ascii_sprite')
local AsciiRenderer = require('ascii.ascii_renderer')
local AsciiShip = require('ascii.ascii_ship')
local Renderer = require('display.renderer')
local Baddie = require('entities.baddie')

local ship_renderer = Renderer(7, 70, 27, 21, label_font, char_font)
local landlubber_renderer = Renderer(7, 70, 27, 21, label_font, char_font)

local hud_renderer = Renderer(7, 70 + 20 * TILE_H, 40, 20, label_font, char_font)

local world_renderer = Renderer(267, 50, 58, 20,label_font,char_font)
local character_renderer


local move_history = {}

local shadow_canvas = love.graphics.newCanvas(world_renderer.width, world_renderer.height)
local lighting_canvas = love.graphics.newCanvas(world_renderer.width, world_renderer.height)
local noise_canvas = love.graphics.newCanvas(world_renderer.width, world_renderer.height)

LANTERN_TTL = 0.5

local lantern_flicker = {seed=0, ttl=LANTERN_TTL}
local moonlight = 0

WorldMapState = {}

baddies = {}

function removeBaddie(baddie)
  for k,v in pairs(baddies) do
      if baddie == v then table.remove(baddies, k) break end
  end
end

function WorldMapState:init()
  local ship = AsciiRenderer()
  ship:add(AsciiSprite(SHIP_BG))
  local water_bg = AsciiSprite(WATER_ANIMATION, Colour(96,120,144,255))
  water_bg.framerate = 20
  water_bg.y = 10
  ship:add(water_bg)
  ship:add(AsciiShip(SHIP_FRIGGATTE))
  ship:add(AsciiSprite(WATER_ANIMATION))
  ship_renderer:setAscii(ship)

  local hud = AsciiRenderer()
  hud:add(AsciiSprite(HUD_BORDER))
  hud_renderer:setAscii(hud)

  local landlubber = AsciiRenderer()
  landlubber:add(AsciiSprite(LANDLUBBER_ANIMATION))
  landlubber_renderer:setAscii(landlubber)

  move(player.position.x, player.position.y)

  for bx=player.position.x-world_renderer.w, player.position.x+world_renderer.w, 1 do
    -- numwater = 0
    if bx > 1 and bx < #world['base'] then
      for by=player.position.y-world_renderer.h, player.position.y+world_renderer.h, 1 do
        if by > 1 and by < #world['base'][bx] and world['base'][bx][by].type == water and math.random(1,100) > 99 then
          table.insert(baddies, Baddie(bx, by))
        end
      end
    end
  end

  --   numwater = 0
  --   for by=player.position.y-world_renderer.h, player.position.y+world_renderer.h, 1 do
  --     if world['base'][bx] ~= nil then
  --       if world['base'][bx][by] ~= nil then
  --         if world['base'][bx][by].type == water then numwater = numwater + 1 end
  --       end
  --     end
  --   end
  --   if numwater > 0 and math.random(1,2) == 1 then
  --     bpos = self:addBaddieOnLine(bx)
  --     table.insert(baddies, Baddie(bpos.x, bpos.y))
  --   end
  -- end

end

function WorldMapState:addBaddieOnLine(x)
  y = math.random(player.position.y-world_renderer.h, player.position.y+world_renderer.h)
  if world['base'][x] ~= nil then
    if world['base'][x][y] ~= nil then
      if world['base'][x][y].type == water then
        print(x .. ':' .. y)
        return {x=x, y=y}
      else
        return self:addBaddieOnLine(x)
      end

    else
      return self:addBaddieOnLine(x)
    end

  else
    return self:addBaddieOnLine(x)
  end
end

function WorldMapState:drawLights(dt, radius_modifier)
  local x, y
  local offset_x, offset_y = player.camera.x - (world_renderer.cols / 2) + 1, player.camera.y - (world_renderer.rows / 2) + 1

  love.graphics.setColor(255, 255, 255, 255)

    -- town lantern
  for k, t in ipairs(world.towncache) do
    x = (t.x - offset_x) * TILE_W
    y = (t.y - offset_y) * TILE_H

    love.graphics.circle('fill', x + (TILE_W / 2), y + (TILE_H / 2), 40 + radius_modifier + math.random(0, 1), 8)
  end

  -- baddie lantern
  for k, b in ipairs(baddies) do
    x = (b.x - offset_x) * TILE_W
    y = (b.y - offset_y) * TILE_H

    love.graphics.circle('fill', x + (TILE_W / 2), y + (TILE_H / 2), 40 + radius_modifier + math.random(0, 1), 8)
  end

  -- player lantern
  x = (player.ship.x - offset_x) * TILE_W
  y = (player.ship.y - offset_y) * TILE_H

  love.graphics.push()
  love.graphics.translate(x + (TILE_W / 2), y + (TILE_H / 2))
  -- love.graphics.rotate(seed * (2 * math.pi))
  -- love.graphics.circle('fill', 0, 0, 68 + radius_modifier, 7 + (seed > 0.5 and 1 or 0))
  love.graphics.circle('fill', 0, 0, 68 + radius_modifier + math.random(0, 1), 8)
  love.graphics.pop()

  if not player:isSailing() then
    x = (player.position.x - offset_x) * TILE_W
    y = (player.position.y - offset_y) * TILE_H

    love.graphics.push()
    love.graphics.translate(x + (TILE_W / 2), y + (TILE_H / 2))
    love.graphics.rotate(seed * (2 * math.pi))
    love.graphics.circle('fill', 0, 0, 30 + radius_modifier + math.random(0, 1), 30)
    love.graphics.pop()
  end
end

function WorldMapState:draw(dt)

  hud_renderer:draw(dt)
  -- love.graphics.setColor(255, 255, 255, 255)
  -- love.graphics.rectangle('line', hud_renderer.x, hud_renderer.y, hud_renderer.width, hud_renderer.height)
  if player:isSailing() then
    ship_renderer:draw(dt)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(char_font)
    local shipTitle = ' - ' .. player.ship.name .. ' - '
    local shipTitleWidth = char_font:getWidth(shipTitle)
    love.graphics.print(shipTitle, ship_renderer.x + ((ship_renderer.width - shipTitleWidth) / 2), ship_renderer.y - TILE_H)
  else
    landlubber_renderer:draw(dt)
  end

  if world_renderer ~= nil then
    world_renderer:draw(dt)
  end

  if character_renderer ~= nil then
    love.graphics.push()
    love.graphics.translate(world_renderer.x, world_renderer.y)
    love.graphics.translate(-player.camera.x * TILE_W, -player.camera.y * TILE_H)
    world_renderer:setScissor()
    character_renderer:draw(dt)
    love.graphics.setScissor()
    love.graphics.pop()
  end

  if moonlight > 0 then

    -- local center_x, center_y = player.camera.x-(world_renderer.w/2), player.camera.y-(world_renderer.h/2)
    -- center_x, center_y = ((player.position.x - center_x) * TILE_W) - TILE_W, ((player.position.y - center_y) * TILE_H) - TILE_H

    -- noise_canvas:clear()

    -- local time = love.timer.getTime()
    -- local seed = world.date % (math.pi * 2)

    -- love.graphics.setCanvas(noise_canvas)
    -- love.graphics.setColor(255, 255, 255, 255)
    -- love.graphics.setShader(shaders.static)
    -- shaders.static:send('seed', time)
    -- love.graphics.rectangle('fill', 0, 0, shadow_canvas:getWidth(), shadow_canvas:getHeight())
    -- love.graphics.setShader()
    -- love.graphics.setCanvas()

    lighting_canvas:clear()

    love.graphics.setCanvas(lighting_canvas)
    -- love.graphics.setShader(shaders.perlin)
    shaders.uniform_static:send('seed', love.math.random())
    love.graphics.setShader(shaders.uniform_static)

    math.randomseed(lantern_flicker.seed)

    WorldMapState:drawLights(dt, 0)

    love.graphics.setShader()

    WorldMapState:drawLights(dt, -3)

    love.graphics.setCanvas()

    shadow_canvas:clear()

    love.graphics.setCanvas(shadow_canvas)
    -- fill the canvas black
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.rectangle('fill', 0, 0, shadow_canvas:getWidth(), shadow_canvas:getHeight())
    -- cut out the lighting
    love.graphics.setBlendMode('subtractive')
    -- love.graphics.setBlendMode('premultiplied')
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(lighting_canvas)

    love.graphics.setCanvas()

    love.graphics.setBlendMode('alpha')
    -- love.graphics.setShader(shaders.blur)
    -- shaders.blur:send('imageSize', {shadow_canvas:getWidth(), shadow_canvas:getHeight()})
    -- shaders.blur:send('radius', 0.5)
    love.graphics.setColor(255, 255, 255, DARKEST_NIGHT * moonlight)
    love.graphics.draw(shadow_canvas, world_renderer.x, world_renderer.y)

    love.graphics.setShader()

  end

  love.graphics.setColor(255,255,255,255)
  love.graphics.setFont(info_font)
  local crewmember
  for i=1, #player.crew do
    crewmember = player.crew[i]
    love.graphics.print('☠', 10 + TILE_W * 2 + 5, 70 + 20 * TILE_H + 30 + (24 * (i - 1)))
  end

  love.graphics.push()
  love.graphics.translate(world_renderer.x, world_renderer.y)
  love.graphics.scale(TILE_W, TILE_H)
  love.graphics.translate(-player.camera.x, -player.camera.y)
  love.graphics.translate(29, 10)
  love.graphics.setLineWidth(1.0 / 29.0, 1.0 / 10.0)

  for i=1, #baddies do
    local baddie = baddies[i]
    love.graphics.setColor(255, 0, 0, 255)
    if baddie.destination ~= nil then
      love.graphics.line(baddie.x - 0.5, baddie.y - 0.5, baddie.destination.x - 0.5, baddie.destination.y - 0.5)
    end

    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.rectangle('line', baddie.x - 1, baddie.y - 1, 1, 1)
    if baddie.path then
      for node, count in baddie.path:nodes() do
        if world.map[node:getX()][node:getY()] == 1 then
          love.graphics.setColor(255, 255, 255, 255)
        else
          love.graphics.setColor(255, 255, 0, 255)
        end
        love.graphics.rectangle('line', node:getX() - 1, node:getY() - 1, 1, 1)
      end
    end
  end

  love.graphics.pop()

  love.graphics.setColor(42,143,189,255)
  love.graphics.setFont(char_font)


  for i=1, #player.crew do
    crewmember = player.crew[i]
    love.graphics.print(crewmember.name, 10 + TILE_W * 2 + 29, 70 + 20 * TILE_H + 38 + (24 * (i - 1)))
  end

  love.graphics.setColor(255,255,255,255)
  love.graphics.print(' - ' .. os.date('%A, %d %B ', world.date) .. world.year .. ' - ' , 267 + (14 * TILE_W), 50 - TILE_H)

  world_renderer:setScissor()
  world_renderer:drawLabels()
  love.graphics.setScissor()

end

function WorldMapState:keypressed(key, unicode)
  press(key)
end

function WorldMapState:update(dt)
  lantern_flicker.ttl = lantern_flicker.ttl - dt
  if lantern_flicker.ttl <= 0 then
    -- lantern_flicker.seed = love.math.random()
    lantern_flicker.seed = love.timer.getTime()
    lantern_flicker.ttl = LANTERN_TTL
  end

  world.date = world.date + (dt * (DAY_IN_SECONDS * (1 / SECONDS_PER_DAY)))

  local percentage_of_day = ((world.date % DAY_IN_SECONDS) / DAY_IN_SECONDS)
  moonlight = percentage_of_day * (2 * math.pi)
  moonlight = math.cos(moonlight)
  moonlight = fn.clamp(0, moonlight * 2, 1)
  -- moonlight = 1

  hud_renderer:update(dt)

  if player:isSailing() then
    ship_renderer:update(dt)
  else
    landlubber_renderer:update(dt)
  end

  local char
  if world_renderer ~= nil then
    local center_x, center_y = player.camera.x-(world_renderer.w/2), player.camera.y-(world_renderer.h/2)

    for x=1, world_renderer.w do
      for y=1, world_renderer.h do
        char = world:getChar(x+center_x, y+center_y)
        --char = Char:new(x, y, '█', {1,0,0,1})
        if char ~= nil then
          world_renderer:drawChar(x, y, char)
        else
          world_renderer:drawChar(x,y, Char:new(x,y,'░', Colour(100,233,161,255), nil))
        end
      end
    end

    local x, y, move
    -- print a wake and reduce the ttl of each move
    for i = 1, #move_history do
      move = move_history[i]
      move.ttl = math.max(0, move.ttl - dt)
      x, y = move.x - center_x, move.y - center_y
      world_renderer:drawChar(x, y, Char:new(move.x, move.y, '≋', Colour(255,255,255,math.min(move.ttl * 255, 255)), Colour(50,169,167,255)))
    end
    -- remove dead moves
    for i=#move_history,1,-1 do
      if move_history[i].ttl == 0 then
        table.remove(move_history, i)
      end
    end

    world_renderer:drawChar(player.ship.x - center_x, player.ship.y - center_y, Char:new(player.ship.x,player.ship.y,'%', Colour(184,149,91,255), Colour(164,133,81,255)))

    character_renderer = Sprite()

    local b
    for k,val in ipairs(baddies) do
      b = baddies[k]
      b:update(dt)
      if not b.is_ghost or moonlight ~= 0 then
        checkForFight()
        if b.is_ghost then
          b.foreground.a = moonlight * 255
          b.background.a = moonlight * 255
        end
        character_renderer:add(
          BufferChar:new(
            ((b.x + 29) - 1) * TILE_W,
            ((b.y + 10) - 1) * TILE_H,
            '✺',
            b.foreground,
            b.background,
            char_font
          )
        )
      end
    end

    if not player:isSailing() then
      character_renderer:add(
        BufferChar:new(
          ((player.position.x + 29) - 1) * TILE_W,
          ((player.position.y + 10) - 1) * TILE_H,
          '!',
          Colour(0,0,0,255),
          nil,
          char_font
        )
      )
      -- world_renderer:drawChar(player.ship.x - center_x, player.ship.y - center_y, Char:new(player.ship.x,player.ship.y,'☃', Colour(184,149,91,255), nil))
    end

    world_renderer:update(dt)
    character_renderer:update(dt)
  end
end

function press(code)
  if code == 'right' then
    move(player.position.x + 1, player.position.y)
  elseif code == 'left' then
    move(player.position.x - 1, player.position.y)
  elseif code == 'up' then
    move(player.position.x, player.position.y -1)
  elseif code == 'down' then
    move(player.position.x, player.position.y + 1)
  end
end

function checkForFight()
  fn.map(function(baddie)
    if baddie.x == player.position.x and baddie.y == player.position.y and (not baddie.is_ghost or moonlight > 0) then
      FightState.baddie = baddie
      Gamestate.switch(FightState)
    end
  end, baddies)
end

function gotoTown(t)
  TownViewState.town = t
  Gamestate.switch(TownViewState)
end

function move(toposx, toposy)
  local tochar = world:getChar(toposx, toposy)
  if tochar == nil then
    return
  end

  if tochar.type == town then
    t = world:getTown(toposx, toposy)
    gotoTown(t)
  else
    sailing = tochar.type == water and player:isSailing()

    if sailing then
      -- keep a record of the last 5 moves for drawing the wake
      if toposx ~= player.position.x or toposy ~= player.position.y then
        if #move_history > 5 then table.remove(move_history, 1) end
        table.insert(move_history, {x=player.position.x, y=player.position.y, ttl=0.8})
      end
    end

    if sailing or tochar.type ~= water or (toposx == player.ship.x and toposy == player.ship.y) then
      player.position.x, player.position.y = toposx, toposy
    end

    if sailing then
      player.ship.x, player.ship.y = player.position.x, player.position.y
    end

    if tochar.type == treasure then
      player.money = player.money + love.math.random(50, 1000)
      tochar.type = dirt
      tochar.colour = Colour(0, 0, 0, 255)
    end

    -- move the camera the the player attempts to move outside the deadzone
    local offset_x, offset_y = player.position.x - player.camera.x, player.position.y - player.camera.y
    if math.abs(offset_x) > DEADZONE_X then
      player.camera.x = player.camera.x + math.min(math.max(offset_x, -1), 1)
    end
    if math.abs(offset_y) > DEADZONE_Y then
      player.camera.y = player.camera.y + math.min(math.max(offset_y, -1), 1)
    end

    checkForFight()
  end

  local towns = world:getTowns(player.camera.x-(world_renderer.w/2), player.camera.y-(world_renderer.h/2), player.camera.x+(world_renderer.w/2), player.camera.y+(world_renderer.h/2))
  world_renderer:clearLabels()
  for k,v in ipairs(towns) do
    local label = Label(((v.x-player.camera.x)*TILE_W)+(world_renderer.w*TILE_W/2)+world_renderer.x, ((v.y-player.camera.y)*TILE_H)+(world_renderer.h*TILE_H/2)+world_renderer.y, Colour(0,0,0,150), Colour(255,100,100,255), v.town.name, world_renderer.label_font)
    world_renderer:addLabel(label)
  end
end
