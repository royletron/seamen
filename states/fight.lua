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
  self.position = {x=0, y=-1}
  self.maxposition = {x=2, y=#player.crew-1}
  self.buttons = {}
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
    table.insert(self.buttons, Button(340, 338 + (28 * (i - 1)), 54, 20, 'shoot', self.position, {x=0, y=i-1}))
    table.insert(self.buttons, Button(404, 338 + (28 * (i - 1)), 60, 20, 'defend', self.position, {x=1, y=i-1}))
    table.insert(self.buttons, Button(474, 338 + (28 * (i - 1)), 54, 20, 'steer', self.position, {x=2, y=i-1}))
  end
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

end

function FightState:draw(dt)
  for key, renderer in pairs(renderers) do
    renderer:draw(dt)
  end
  self:drawPlayerData(dt)
  for key, button in pairs(self.buttons) do
    button:draw(dt)
  end
  if self.position.y ~= -1 then self:drawSelectedData(dt) end
  for i=1, #self.crew_progress, 1 do
    self.crew_progress[i]:draw(dt)
  end
end

function FightState:drawSelectedData(dt)
  local crewmember = player.crew[self.position.y + 1]
  love.graphics.print('EXP = '..crewmember.exp, 640, 340)
  love.graphics.print('DEF = '..crewmember.def, 640, 368)
  love.graphics.print('ATK = '..crewmember.atk, 640, 392)
  love.graphics.print('EVA = '..crewmember.eva, 640, 421)
  love.graphics.print('ACC = '..crewmember.acc, 640, 449)
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
      if progress.value == progress.max then
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
  self:updatePlayerData(dt)
  for i=1, #self.crew_progress, 1 do
    self.crew_progress[i]:update(dt)
  end
end
