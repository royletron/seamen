Sprite = require 'Sprite'
Square = Sprite:extends{size = 0}

function Square:__init(x,y,size, colour)
  self.x, self.y, self.size, self.colour = x,y,size,colour
end

function Square:draw(dt)
  love.graphics.setColor(self.colour.r, self.colour.g, self.colour.b, self.colour.a)
  love.graphics.rectangle("fill", self.x, self.y, self.size, self.size )
  Square.super.draw(dt)
end

return Square