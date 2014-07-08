require('ascii.ships')
local AsciiSprite = require('ascii.ascii_sprite')
local AsciiShip = require('ascii.ascii_ship')
local Renderer = require('display.renderer')
local ProgressBar = require('display.progress_bar')
--AvatarTalker = require('display.AvatarTalker')

shoot = 1
defend = 2
steer = 3

local fightcontrols = {x=0, y=380}

FightState = {baddie = nil}

local projectiles = {}

local renderers = {
  ship_renderer = Renderer(7, 70, 98, 21, label_font, char_font),
  hud_renderer = Renderer(7, 70 + 20 * TILE_H, 40, 20, label_font, char_font)
}

--local crest_renderer = Renderer(7, 70, 28, 20,label_font,char_font)

function FightState:enter()
  self.position = {x=0, y=-1}
  self.maxposition = {x=2, y=#player.crew-1}
  self.buttons = {}
  local ship = AsciiRenderer()
  ship:add(AsciiSprite(FIGHT_BG))
  local water_bg = AsciiSprite(WATER_ANIMATION, Colour(96,120,144,255))
  water_bg.framerate = 10
  water_bg.y = 10
  ship:add(water_bg)
  self.playersprite = AsciiShip(SHIP_FRIGGATTE)
  self.playersprite.x = 10
  self.baddiesprite = AsciiShip(self.baddie.ascii)
  self.baddiesprite.x = 60
  ship:add(self.playersprite)
  ship:add(self.baddiesprite)
  ship:add(AsciiSprite(WATER_ANIMATION))
  renderers.ship_renderer:setAscii(ship)
  self.crew_progress = {}
  for i=1, #player.crew do
    local crewmember = player.crew[i]
    crewmember.currentaction = 0
    table.insert(self.crew_progress, ProgressBar(320, fightcontrols.y + (28 * (i - 1)), 10, 0, 10))
    table.insert(self.buttons, Button(410, fightcontrols.y + (28 * (i - 1)), 54, TILE_H, 'shoot', self.position, {x=0, y=i-1}))
    table.insert(self.buttons, Button(474, fightcontrols.y + (28 * (i - 1)), 60, TILE_H, 'defend', self.position, {x=1, y=i-1}))
    table.insert(self.buttons, Button(544, fightcontrols.y + (28 * (i - 1)), 54, TILE_H, 'steer', self.position, {x=2, y=i-1}))
  end
  self.playerhealth = ProgressBar(120, 320, 20, 0, player.maxhealth)
  self.baddiehealth = ProgressBar(520, 320, 20, 0, self.baddie.maxhealth)
end

function FightState:keypressed(key, unicode)
  if key == 'down' then self:moveCursor('y', 1) end
  if key == 'up' then self:moveCursor('y', -1) end
  if key == 'right' then self.position.x = self.position.x + 1 end
  if key == 'left' then self.position.x = self.position.x - 1 end
  if key == 'escape' then Gamestate.switch(WorldMapState) end
  if key == 'z' then self:triggerButton() end

  if self.position.x < 0 then self.position.x = 0 end
  if self.position.x > self.maxposition.x then self.position.x = self.maxposition.x end
  --if self.position.y < 0 then self.position.y = 0 end
  --if self.position.y > self.maxposition.y then self.position.y = self.maxposition.y end
end

function FightState:moveCursor(plane, val)
  local max = self.maxposition.y
  if plane == 'x' then max = self.maxposition.x end
  local loc = self.position.y
  if plane == 'x' then loc = self.position.x end
  local found = false
  for i=1, max, 1 do
    loc = loc + val
    if loc > max then loc = 0 end
    if loc < 0 then loc = max end
    --if loc < 0 then loc = max - 1 end
    local current = self.buttons[(loc*3)+1]
    if current.active == true or found == true then
      found = true
      break
    end
  end
  if found == false then
    loc = -1
  end
  if plane == 'y' then self.position.y = loc
  else self.position.x = loc
  end
end

function FightState:triggerButton()
  if self.position.y > -1 then
    local crewmember = player.crew[self.position.y + 1]
    local action = self.position.x + 1
    crewmember.currentaction = action
    if action == shoot then
      local shotresult = player:shoot(crewmember, self.baddie)
      local endx = 70
      if shotresult.hit == true then
        if math.random(1,10) > 5 then endx = 50 else endx = 90 end
      end
      table.insert(projectiles, {result = shotresult, counter = 0, startx = 20, starty = 20, endx = endx, endy = 20, bezierx = (endx-20) + math.floor(math.random(0,5)), beziery = 5 + math.floor(math.random(0,5)), framerate = 10, position = 0, sprite = AsciiSprite(CANNONBALL)})
      if shotresult.hit == true then self.baddie.health = self.baddie.health - math.floor(shotresult.value) end
    end
    local progress = self.crew_progress[self.position.y + 1]
    progress:setValue(0)
    self:moveCursor('y', 1)
  end
end

function FightState:draw(dt)
  for key, renderer in pairs(renderers) do
    renderer:draw(dt)
  end
  self:drawPlayerData(dt)
  self:drawShipStatuses(dt)
  for key, button in pairs(self.buttons) do
    button:draw(dt)
  end
  if self.position.y ~= -1 then self:drawSelectedData(dt) end
  for i=1, #self.crew_progress, 1 do
    self.crew_progress[i]:draw(dt)
  end
end

function FightState:drawShipStatuses(dt)
  love.graphics.setColor(255,255,255,255)
  love.graphics.printf(player.ship.name, 100, 300, 200, "center")
  love.graphics.printf(self.baddie.ship.name.." (lvl "..self.baddie.level..")", 500, 300, 200, "center")
  love.graphics.print(player.health .. '/' .. player.maxhealth, 285, 320)
  love.graphics.print(self.baddie.health .. '/' .. self.baddie.maxhealth, 685, 320)
  love.graphics.setColor(254,67,101,255)
  love.graphics.print('♥', 105, 320)
  love.graphics.print('♥', 505, 320)
  self.playerhealth:draw(dt)
  self.baddiehealth:draw(dt)
end

function FightState:drawSelectedData(dt)
  local crewmember = player.crew[self.position.y + 1]
  love.graphics.setColor(255,255,255,255)
  love.graphics.print('LVL = '..crewmember.level, 640, fightcontrols.y)
  love.graphics.print('DEF = '..crewmember.def, 640, fightcontrols.y+28)
  love.graphics.print('ATK = '..crewmember.atk, 640, fightcontrols.y+52)
  love.graphics.print('EVA = '..crewmember.eva, 640, fightcontrols.y+79)
  love.graphics.print('ACC = '..crewmember.acc, 640, fightcontrols.y+109)
  local pos = fightcontrols.y + (28 * (self.position.y)) - 4
  if self.position.y == 0 then
    love.graphics.line(50,pos, 630,pos, 720,fightcontrols.y-4, 720,fightcontrols.y+130, 630,fightcontrols.y+130, 630,pos+24, 50,pos+24, 50,pos)
  else
    love.graphics.line(50,pos, 630,pos, 630,fightcontrols.y-4, 720,fightcontrols.y-4, 720,fightcontrols.y+130, 630,fightcontrols.y+130, 630,pos+24, 50,pos+24, 50,pos)
  end
end

function FightState:drawPlayerData(dt)
  for i=1, #player.crew do
    crewmember = player.crew[i]
    local action = ''
    if crewmember.currentaction > 0 then
      if crewmember.currentaction == shoot then action = ' is shooting' end
      if crewmember.currentaction == defend then action = ' is defending' end
      if crewmember.currentaction == steer then action = ' is steering' end
    end
    love.graphics.print(crewmember.name..action, 10 + TILE_W * 2 + 29, fightcontrols.y + (28 * (i - 1)))
  end
end

function FightState:updatePlayerData(dt)

  self.playerhealth:setValue(player.health)
  self.baddiehealth:setValue(self.baddie.health)
  self.playerhealth:update(dt)
  self.baddiehealth:update(dt)

  for i=1, #player.crew do
    local progress = self.crew_progress[i]
    local crewmember = player.crew[i]
    if progress.value == progress.max then

    else
      progress:setValue(progress.value + player.crew[i].speed)
      if progress.value == progress.max then
        crewmember.currentaction = 0
        self.buttons[((i-1)*3)+1].active = true
        self.buttons[((i-1)*3)+2].active = true
        self.buttons[((i-1)*3)+3].active = true
      else
        if self.position.y == i-1 then self:moveCursor('y', 1) end

        self.buttons[((i-1)*3)+1].active = false
        self.buttons[((i-1)*3)+2].active = false
        self.buttons[((i-1)*3)+3].active = false
      end
    end
  end
end

function FightState:update(dt)
  for key, renderer in pairs(renderers) do
    renderer:update(dt)
  end
  for key, projectile in pairs(projectiles) do

  end
  self:updatePlayerData(dt)
  for i=1, #self.crew_progress, 1 do
    self.crew_progress[i]:update(dt)
  end
end
