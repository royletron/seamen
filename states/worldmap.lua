require('ascii.ships')
require('ascii.hud')

AsciiSprite = require('ascii.ascii_sprite')
AsciiRenderer = require('ascii.ascii_renderer')
Renderer = require('renderer')

local renderers = {
  ship_renderer = Renderer(7, 70, 28, 20, label_font, char_font),
  hud_renderer = Renderer(7, 70 + 20 * TILE_H, 40, 20, label_font, char_font)
}

local world_renderer = Renderer(267, 50, 58, 20,label_font,char_font)

WorldMapState = {}

function WorldMapState:init()
  ship = AsciiRenderer()
  ship:add(AsciiSprite(SHIP_FRIGGATTE))
  ship:add(AsciiSprite(WATER_ANIMATION))
  renderers.ship_renderer:setAscii(ship)

  hud = AsciiRenderer()
  hud:add(AsciiSprite(HUD_BORDER))
  renderers.hud_renderer:setAscii(hud)

  move(player.position.x, player.position.y)
end

function WorldMapState:draw(dt)

  for key, renderer in pairs(renderers) do
    renderer:draw(dt)
  end

  if world_renderer ~= nil then
    world_renderer:draw(dt)
  end

  love.graphics.setColor(255,255,255,255)
  love.graphics.setFont(info_font)
  for i=1, #player.crew do
    crewmember = player.crew[i]
    love.graphics.print('☠', 10 + TILE_W * 2 + 5, 70 + 20 * TILE_H + 30 + (24 * (i - 1)))
  end

  love.graphics.setColor(42,143,189,255)
  love.graphics.setFont(char_font)

  for i=1, #player.crew do
    crewmember = player.crew[i]
    love.graphics.print(crewmember.name, 10 + TILE_W * 2 + 29, 70 + 20 * TILE_H + 38 + (24 * (i - 1)))
  end

end

function WorldMapState:keypressed(key, unicode)
  press(key)
end

function WorldMapState:update(dt)
  for key, renderer in pairs(renderers) do
    renderer:update(dt)
  end
  if world_renderer ~= nil then
    for x=0, world_renderer.w, 1 do
      for y=0, world_renderer.h, 1 do
        char = world:getChar(x+player.position.x-(world_renderer.w/2), y+player.position.y-(world_renderer.h/2))
        --char = Char:new(x, y, '█', {1,0,0,1})
        if char ~= nil then
          if char.x==player.position.x and char.y==player.position.y then
            world_renderer:drawChar(x,y,Char:new(x,y,'✺', Colour(184,149,91,255), Colour(164,133,81,255)))
          else
            world_renderer:drawChar(x, y, char)
          end
        else
          world_renderer:drawChar(x,y, Char:new(x,y,'░', Colour(100,233,161,255), Colour(255,233,161,0)))
        end
      end
    end
    world_renderer:update(dt)
  end
end

function press(code)
  if code == 'right' then
    move(player.position.x + 1, player.position.y)
  end
  if code == 'left' then
    move(player.position.x - 1, player.position.y)
  end
  if code == 'up' then
    move(player.position.x, player.position.y -1)
  end
  if code == 'down' then
    move(player.position.x, player.position.y + 1)
  end
end

function gotoTown(t)
  TownViewState.town = t
  Gamestate.switch(TownViewState)
end

function move(toposx, toposy)
  tochar = world:getChar(toposx, toposy)
  if tochar.type == water then
    player.position.x, player.position.y = toposx, toposy
  end
  if tochar.type == town then
    t = world:getTown(toposx, toposy)
    gotoTown(t)
  end
  towns = world:getTowns(player.position.x-(world_renderer.w/2), player.position.y-(world_renderer.h/2), player.position.x+(world_renderer.w/2), player.position.y+(world_renderer.h/2))
  world_renderer:clearLabels()
  for k,v in ipairs(towns) do
    label = Label(((v.x-player.position.x)*TILE_W)+(world_renderer.w*TILE_W/2)+world_renderer.x, ((v.y-player.position.y)*TILE_H)+(world_renderer.h*TILE_H/2)+world_renderer.y, Colour(0,0,0,150), Colour(255,100,100,255), v.town.name, world_renderer.label_font)
    world_renderer:addLabel(label)
  end
end
