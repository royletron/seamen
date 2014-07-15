local PlayerShipDisplay = require('display.PlayerShipDisplay')

FightEndState = {}

function FightEndState:init()
  self.exp = 0
  self.ship_renderer = PlayerShipDisplay(300, 100)
end

function FightEndState:enter()

end

function FightEndState:update(dt)
  self.ship_renderer:update(dt)
end

function FightEndState:draw(dt)
  self.ship_renderer:draw(dt)
  love.graphics.setColor(255,255,255,255)
  love.graphics.printf(player.ship.name .. ' lv' .. player.level, self.ship_renderer.x, self.ship_renderer.y + self.ship_renderer.height + 10, self.ship_renderer.width, "center")
end

return FightEndState
