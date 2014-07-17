local PlayerShipDisplay = require('display.PlayerShipDisplay')
local ProgressBar = require('display.progress_bar')

FightEndState = {exp=0}

local counter = 0
local framerate = 3

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
  self.ship_renderer:update(dt)
  if self.expstarted == true then
    counter = counter + 1
    if counter > framerate then
      if self.exprunning == true then
        local currentlevel = player.level
        player:addExp(1)
        if currentlevel ~= player.level then
          self.exp_bar.max = player:getMaxExp()
        end
        self.exp_bar:setValue(player.exp)
        self.exp_bar:update(dt)
        self.counter = self.counter + 1
        print(self.counter .. "::" .. self.exp)
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
  love.graphics.setColor(255,255,255,255)
  if self.exp - self.counter > 0 then
    love.graphics.print('EXP Earned '..self.exp-self.counter, self.ship_renderer.x, self.ship_renderer.y+240)
  else
    love.graphics.print('Finished', self.ship_renderer.x, self.ship_renderer.y+240)
  end
  love.graphics.printf(player.exp, self.exp_bar.x - 85, self.exp_bar.y, 80, "right")
  love.graphics.printf(player:getMaxExp(), self.exp_bar.x + self.ship_renderer.width + 5, self.exp_bar.y, 80, "left")
  love.graphics.printf(player.ship.name, self.ship_renderer.x, self.ship_renderer.y - 20, self.ship_renderer.width, "center")
end

return FightEndState
