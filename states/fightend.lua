local PlayerShipDisplay = require('display.PlayerShipDisplay')
local ProgressBar = require('display.progress_bar')
local tween = require('hump.tween')

FightEndState = {exp=0}

local counter = 0
local framerate = 3
local levelscale = {val = 1}
local levelcolour = Colour(255,255,255,255)

function FightEndState:init()
  self.ship_renderer = PlayerShipDisplay(300, 100)
  self.exp_bar = ProgressBar(300, 370, 27, 0, player:getMaxExp())
  self.exp_bar:setValue(player.exp)
end

function FightEndState:enter()
  self.counter = 0
  self.expstarted = false
  self.exprunning = true
end

function FightEndState:triggerButton()
  if self.expstarted == false then self.expstarted = true end
end

function FightEndState:keypressed(key, unicode)
  if key == 'z' then self:triggerButton() end
end

function FightEndState:update(dt)
  if self.levelscaletween ~= nil then self.levelscaletween:update(dt) end
  if self.levelcolourtween ~= nil then self.levelcolourtween:update(dt) end
  self.ship_renderer:update(dt)
  if self.expstarted == true then
    counter = counter + 1
    if counter > framerate then
      if self.exprunning == true then
        local currentlevel = player.level
        player:addExp(1)
        if currentlevel ~= player.level then
          self.exp_bar.max = player:getMaxExp()
          levelscale.val = 1.5
          levelcolour.r = 0
          self.levelscaletween = tween.new(0.4, levelscale, {val = 1})
          self.levelcolourtween = tween.new(0.5, levelcolour, {r = 255})
        end
        self.exp_bar:setValue(player.exp)
        self.exp_bar:update(dt)
        self.counter = self.counter + 1
        if self.counter >= self.exp then
          self.exprunning = false
        end
      else
      end
      counter = 0
    end
  end
end

function FightEndState:draw(dt)
  self.ship_renderer:draw(dt)
  self.exp_bar:draw(dt)
  love.graphics.setColor(40, 255, 40, 255)
  love.graphics.printf(player.ship.name..' wins!', self.ship_renderer.x, self.ship_renderer.y - 20, self.ship_renderer.width, "center")
  love.graphics.setColor(255,255,255,255)
  if self.exp - self.counter > 0 then
    love.graphics.print('EXP '..self.exp-self.counter, self.ship_renderer.x, self.ship_renderer.y+240)
  else
    love.graphics.print('Finished', self.ship_renderer.x, self.ship_renderer.y+240)
  end
  love.graphics.printf(player.exp, self.exp_bar.x - 85, self.exp_bar.y, 80, "right")
  love.graphics.printf(player:getMaxExp(), self.exp_bar.x + self.ship_renderer.width + 5, self.exp_bar.y, 80, "left")
  love.graphics.print('Level ', self.exp_bar.x, self.exp_bar.y + 30)
  love.graphics.push()
  love.graphics.setColor(levelcolour.r, levelcolour.g, levelcolour.b, levelcolour.a)
  love.graphics.scale(levelscale.val, levelscale.val)
  love.graphics.print(player.level, ((self.exp_bar.x+char_font:getWidth('Level '))/levelscale.val) - ((1-levelscale.val)*15), (self.exp_bar.y + 30 + ((1-levelscale.val)*35))/levelscale.val)
  love.graphics.pop()
end

return FightEndState
