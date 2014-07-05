require('ascii.ships')
AsciiSprite = require('ascii.ascii_sprite')
Renderer = require('display.renderer')
--AvatarTalker = require('display.AvatarTalker')

FightState = {baddie = nil}

local renderers = {
  ship_renderer = Renderer(7, 70, 60, 21, label_font, char_font),
  hud_renderer = Renderer(7, 70 + 20 * TILE_H, 40, 20, label_font, char_font)
}

--local crest_renderer = Renderer(7, 70, 28, 20,label_font,char_font)

function FightState:enter()
  self.position = {x=0, y=0}
  self.maxposition = {x=0, y=0}
  local ship = AsciiRenderer()
  ship:add(AsciiSprite(SHIP_FRIGGATTE))
  ship:add(AsciiSprite(WATER_ANIMATION))
  renderers.ship_renderer:setAscii(ship)
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

end

function FightState:update(dt)
  for key, renderer in pairs(renderers) do
    renderer:update(dt)
  end
end
