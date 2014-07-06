require('ascii.ships')
AsciiSprite = require('ascii.ascii_sprite')
Renderer = require('display.renderer')
ProgressBar = require('display.progress_bar')
--AvatarTalker = require('display.AvatarTalker')

FightState = {baddie = nil}

local renderers = {
  ship_renderer = Renderer(7, 70, 98, 21, label_font, char_font),
  hud_renderer = Renderer(7, 70 + 20 * TILE_H, 40, 20, label_font, char_font)
}

--local crest_renderer = Renderer(7, 70, 28, 20,label_font,char_font)

function FightState:enter()
  self.position = {x=0, y=0}
  self.maxposition = {x=0, y=0}
  local ship = AsciiRenderer()
  ship:add(AsciiSprite(FIGHT_BG))
  self.playersprite = AsciiSprite(SHIP_FRIGGATTE)
  self.playersprite.x = 10
  self.baddiesprite = AsciiSprite(self.baddie.ascii)
  self.baddiesprite.x = 60
  ship:add(self.playersprite)
  ship:add(self.baddiesprite)
  ship:add(AsciiSprite(WATER_ANIMATION))
  renderers.ship_renderer:setAscii(ship)
  self.crew_progress = {}
  for i=1, #player.crew do
    table.insert(self.crew_progress, ProgressBar(250, 340 + (28 * (i - 1)), 10, 0, 10))
  end
end

function FightState:keypressed(key, unicode)
  if key == 'down' then self.position.y = self.position.y + 1 end
  if key == 'up' then self.position.y = self.position.y - 1 end
  if key == 'right' then self.position.x = self.position.x + 1 end
  if key == 'left' then self.position.x = self.position.x - 1 end
  if key == 'escape' then Gamestate.switch(WorldMapState) end
  if key == 'z' then self:triggerButton() end

  if self.position.x < 0 then self.position.x = 0 end
  if self.position.x > self.maxposition.x then self.position.x = self.maxposition.x end
  if self.position.y < 0 then self.position.y = 0 end
  if self.position.y > self.maxposition.y then self.position.y = self.maxposition.y end
end

function FightState:draw(dt)
  for key, renderer in pairs(renderers) do
    renderer:draw(dt)
  end
  self:drawPlayerData(dt)
  for i=1, #self.crew_progress, 1 do
    self.crew_progress[i]:draw(dt)
  end
end

function FightState:drawPlayerData(dt)
  for i=1, #player.crew do
    crewmember = player.crew[i]
    love.graphics.print(crewmember.name, 10 + TILE_W * 2 + 29, 340 + (28 * (i - 1)))
  end
end

function FightState:updatePlayerData(dt)
  for i=1, #player.crew do
    local progress = self.crew_progress[i]
    if progress.value == progress.max then

    else
      progress:setValue(progress.value + player.crew[i].speed)
    end
  end
end

function FightState:update(dt)
  for key, renderer in pairs(renderers) do
    renderer:update(dt)
  end
  self:updatePlayerData(dt)
  for i=1, #self.crew_progress, 1 do
    self.crew_progress[i]:update(dt)
  end
end
