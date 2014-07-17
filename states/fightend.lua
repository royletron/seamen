local PlayerShipDisplay = require('display.PlayerShipDisplay')
local ProgressBar = require('display.progress_bar')

FightEndState = {exp=0}

local counter = 0
local framerate = 2

function FightEndState:init()
  self.ship_renderer = PlayerShipDisplay(300, 100)
  self.exp_bar = ProgressBar(300, 350, 27, 0, player:getMaxExp())
end

function FightEndState:enter()
  print(self.exp)
  self.counter = 0
  self.exprunning = true
end

function FightEndState:update(dt)
  counter = counter + 1
  self.ship_renderer:update(dt)
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

function FightEndState:draw(dt)
  self.ship_renderer:draw(dt)
  self.exp_bar:draw(dt)
  love.graphics.setColor(255,255,255,255)
  love.graphics.print('Experience...', self.ship_renderer.x, self.ship_renderer.y+230)
  love.graphics.printf(player.ship.name, self.ship_renderer.x, self.ship_renderer.y - 20, self.ship_renderer.width, "center")
end

return FightEndState
