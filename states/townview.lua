require('ascii.ships')
AsciiSprite = require('ascii.ascii_sprite')
Renderer = require('renderer')
AvatarTalker = require('display.AvatarTalker')

TownViewState = {town = nil}

local crest_renderer = Renderer(7, 70, 28, 20,label_font,char_font)

function TownViewState:enter()
  crest_renderer:setAscii(AsciiSprite({self.town.crest}))
  self.position = {x=0, y=0}
  self.maxposition = {x=1, y=0}
  self.invoice = {}
  self.talker = AvatarTalker(7, 300, 700, "Welcome to "..self.town.name.." me 'arty!", Colour(255,255,255,255))
end

function TownViewState:draw(dt)
  self.talker:draw(dt)
  love.graphics.setColor(252,251,227,255)
  love.graphics.setFont(char_font);
  love.graphics.printf('Welcome to '..self.town.name,7, 50, 130,"center")
  if crest_renderer ~= nil then
    crest_renderer:draw(dt)
  end
  counter = 0
  for k,v in ipairs(self.town.supplies) do
    if self.invoice[k] == nil then self.invoice[k] = {quantity = 0} end
    love.graphics.setColor(42,143,189,255)
    love.graphics.setFont(char_font);
    love.graphics.print(v.name, 250, 50 + (counter*30))
    love.graphics.setColor(119,204,164,255)
    love.graphics.print('available '..v.stock.." : "..'cost '..v.cost, 390, 50 + (counter*30))
    if self.position.x == 1 and self.position.y == counter then
      love.graphics.setColor(42,143,189,255)
    else
      love.graphics.setColor(102,102,102,255)
    end
    love.graphics.rectangle("fill", 750, 50 + (counter *30) - 3, 20, 20 )
    love.graphics.setColor(255,255,255,255)
    love.graphics.print('+', 756, 50 + (counter * 30))
    if self.position.x == 0 and self.position.y == counter then
      love.graphics.setColor(42,143,189,255)
    else
      love.graphics.setColor(102,102,102,255)
    end
    love.graphics.rectangle("fill", 720, 50 + (counter *30) - 3, 20, 20 )
    love.graphics.setColor(255,255,255,255)
    love.graphics.print('-', 726, 50 + (counter * 30))

    if self.invoice[k].quantity == 0 then
      love.graphics.setColor(102,102,102,255)
      love.graphics.printf('no deal', 600, 50+(counter*30), 100, "right")
    else
      if self.invoice[k].quantity > 0 then
        love.graphics.setColor(119,204,164,255)
        love.graphics.printf('buying '..self.invoice[k].quantity, 600, 50+(counter*30), 100, "right")
      else
        love.graphics.setColor(255,153,153,255)
        love.graphics.printf('selling '..-1*self.invoice[k].quantity, 600, 50+(counter*30), 100, "right")
      end
    end
    self.maxposition.y = counter
    counter = counter + 1
  end
end

function TownViewState:update(dt)
  if crest_renderer ~= nil then
    crest_renderer:update(dt)
  end
  self.talker:update(dt)
end

function TownViewState:triggerButton()
  if self.position.y <= self.maxposition.y then
    if self.invoice[self.position.y+1] == nil then
      self.invoice[self.position.y+1] = {quantity=0}
    end
    if self.position.x == 0 then
      --remove item
      self.invoice[self.position.y+1].quantity = self.invoice[self.position.y+1].quantity - 1
    else
      --add item
      self.invoice[self.position.y+1].quantity = self.invoice[self.position.y+1].quantity + 1
    end
    --must be a counter button?
  else
    --must be something else?
  end
end

function TownViewState:keypressed(key, unicode)
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
