Sprite = require 'display.Sprite'
Label = Sprite:extends{text = ''}

function Label:__init(x,y,bgcolour,colour,text,font)
  self.x, self.y, self.text = x,y,text
  self.colour, self.bgcolour = colour, bgcolour
  self.font = font
end

function Label:draw(dt)
  love.graphics.setFont(self.font);
  love.graphics.setColor(self.bgcolour.r, self.bgcolour.g, self.bgcolour.b, self.bgcolour.a)
  love.graphics.rectangle("fill", self.x-2, self.y-2, (string.len(self.text)*self.font:getWidth(' '))+4, self.font:getHeight()+4)

  love.graphics.setColor(self.colour.r, self.colour.g, self.colour.b, self.colour.a)
  love.graphics.print( self.text, self.x, self.y )

  --Label.super.draw(dt)
end

return Label
