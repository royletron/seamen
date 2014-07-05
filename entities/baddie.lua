class = require '30log'

namegenerator = require 'namegenerator'

Baddie = class ()
Baddie.__name = 'Baddie'

function Baddie:__init(x, y)
  self.x, self.y = x,y
  self.speed = math.random(1,3)
  self.counter = 0
  self.level = math.random(math.max(player.level-2, 1), player.level+2)
end

function Baddie:update(dt)
  self.counter = self.counter + dt
  if self.counter > self.speed then
    self:move()
    self.counter = 0
  end
end

function Baddie:move()
  direction = math.random(1,4)
  if direction == 1 then self:goto(self.x + 1, self.y) end
  if direction == 2 then self:goto(self.x - 1, self.y) end
  if direction == 3 then self:goto(self.x, self.y + 1) end
  if direction == 4 then self:goto(self.x, self.y - 1) end
end

function Baddie:goto(x, y)
  if world['base'][x][y].type == water then self.x, self.y = x, y end
end

return Baddie
