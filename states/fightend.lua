local PlayerShipDisplay = require('display.PlayerShipDisplay')

FightEndState = {}

local ship_renderer = PlayerShipDisplay(300, 100)

function FightEndState:init()
  self.exp = 0
end

function FightEndState:enter()

end

function FightEndState:update(dt)

end

function FightEndState:draw(dt)
  love.graphics.setColor(255,255,255,255)
  love.graphics.printf(player.ship.name .. ' lv' .. player.level, 100, 290, 200, "center")
end

return FightEndState
