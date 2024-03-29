require('ascii.ships')
AsciiSprite = require('ascii.ascii_sprite')
Renderer = require('display.renderer')
AvatarTalker = require('display.AvatarTalker')
Button = require('display.button')

TownViewState = {town = nil}

local crest_renderer = Renderer(7, 80, 28, 20,label_font,char_font)

function TownViewState:init()
  self.talker = AvatarTalker(7, 300, 700, "I am just initin' init!", Colour(255,255,255,255), TOWN_CRIER_STATIC, TOWN_CRIER_TALKING)
  self.position = {x=0, y=0}
  self.buttons = {Button(720, 80 + (#supplies * 30), 50, 20, 'Deal', self.position, {x=-1, y = #supplies})}
  for p=1, #supplies, 1 do
    table.insert(self.buttons, Button(720, 50 + (p*30), 20, 20, '-', self.position, {x=0, y=p-1}))
    table.insert(self.buttons, Button(750, 50 + (p*30), 20, 20, '+', self.position, {x=1, y=p-1}))
  end
end

function TownViewState:enter()
  crest_renderer:setAscii(AsciiSprite({self.town.crest}))
  self.position.x=0
  self.position.y=0
  self.maxposition = {x=1, y=0}
  self.invoice = {}
  self.talker:setText("Welcome to "..self.town.name.." me 'arty!")
end

function TownViewState:draw(dt)
  self.talker:draw(dt)
  love.graphics.setColor(252,251,227,255)
  love.graphics.setFont(char_font);
  love.graphics.printf('Welcome to '..self.town.name,7, 50, 110,"center")
  if crest_renderer ~= nil then
    crest_renderer:draw(dt)
  end
  local counter = 0
  for k,v in ipairs(self.town.supplies) do
    if self.invoice[k] == nil then self.invoice[k] = {quantity = 0} end
    love.graphics.setColor(42,143,189,255)
    love.graphics.setFont(char_font);
    love.graphics.print(v.name, 150, 80 + (counter*30))
    love.graphics.setColor(119,204,164,255)
    love.graphics.print('you have ' .. player:has(v.name) .. ' : available '..v.stock.." : "..'price '..v.cost, 290, 80 + (counter*30))

    if self.invoice[k].quantity == 0 then
      love.graphics.setColor(102,102,102,255)
      love.graphics.printf('no deal', 600, 80+(counter*30), 100, "right")
    else
      if self.invoice[k].quantity > 0 then
        love.graphics.setColor(119,204,164,255)
        love.graphics.printf('buying '..self.invoice[k].quantity, 600, 80+(counter*30), 100, "right")
      else
        love.graphics.setColor(255,153,153,255)
        love.graphics.printf('selling '..-1*self.invoice[k].quantity, 600, 80+(counter*30), 100, "right")
      end
    end
    counter = counter + 1
  end
  self.maxposition.y = counter
  -- if(self.position.y == counter) then
  --   love.graphics.setColor(42,143,189,255)
  -- else
  --   love.graphics.setColor(102,102,102,255)
  -- end
  -- love.graphics.rectangle("fill", 720, 50 + (counter *30) - 3, 50, 20 )
  -- love.graphics.setColor(255,255,255,255)
  -- love.graphics.print('Deal', 726, 50 + (counter * 30))
  for key, button in pairs(self.buttons) do
    button:draw(dt)
  end
end

function TownViewState:update(dt)
  if crest_renderer ~= nil then
    crest_renderer:update(dt)
  end
  self.talker:update(dt)
end

function TownViewState:deal()
  local cost = 0
  local line
  for k,v in ipairs(self.town.supplies) do
    line = self.invoice[k]
    if line ~= nil then
      v.stock = v.stock - line.quantity
      player:setInventory(v.name, line.quantity)
      cost = cost - (v.cost * line.quantity)
    end
    -- if v ~= nil then
    --   if v.quantity == 0 then
    --     print(v.quantity)
    --     for sk, sv in ipairs(self.town.supplies) do
    --       if sv.name == v.name then
    --         sv.quantity = sv.quantity - v.quantity
    --       end
    --     end
    --     player:setInventory(v.name, v.quantity)
    --     cost = cost + (v.cost * v.quantity)
    --   end
    -- end
  end
  player.money = player.money + cost
  self.talker:setText('Deal done gobber!')
  self.invoice = {}
end

function TownViewState:triggerButton()
  if self.position.y <= self.maxposition.y-1 then
    if self.invoice[self.position.y+1] == nil then
      self.invoice[self.position.y+1] = {quantity=0, name=self.town.supplies[self.position.y+1].name, cost=self.town.supplies[self.position.y+1].cost}
    end
    if self.position.x == 0 then
      --remove item
      if self.invoice[self.position.y+1].quantity <= 0 and player:has(self.town.supplies[self.position.y+1].name) > (self.invoice[self.position.y+1].quantity) * -1 then
        self.invoice[self.position.y+1].quantity = self.invoice[self.position.y+1].quantity - 1
      else
        if self.invoice[self.position.y+1].quantity > 0 then
          self.invoice[self.position.y+1].quantity = self.invoice[self.position.y+1].quantity - 1
        else
          if player:has(self.town.supplies[self.position.y+1].name) == 0 then
            self.talker:setText('Sorry buddy you don\'t have any '..self.town.supplies[self.position.y+1].name)
          else
            self.talker:setText('Sorry buddy you don\'t have enough '..self.town.supplies[self.position.y+1].name)
          end
        end
      end
    else
      --add item
      self.invoice[self.position.y+1].quantity = self.invoice[self.position.y+1].quantity + 1
    end
    --must be a counter button?
  else
    self:deal()
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
