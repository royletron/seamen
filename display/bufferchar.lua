Sprite = require 'display.Sprite'
BufferChar = Sprite:extends{'char','size','colour'}
BufferChar.__name = 'BufferChar'

function BufferChar:__init(x,y,char,colour,bgcolour,font)
  self.x,self.y,self.char,self.colour = x,y,char,colour
  self.bgcolour = bgcolour
  self.font = font
end

function BufferChar:draw(dt)

  if self.bgcolour ~= nil then
    love.graphics.setColor(self.bgcolour.r, self.bgcolour.g, self.bgcolour.b, self.bgcolour.a)
    love.graphics.rectangle("fill", self.x, self.y, TILE_W, TILE_H )
  end

  love.graphics.setFont(self.font);

	love.graphics.setColor(self.colour.r, self.colour.g, self.colour.b, self.colour.a)
	love.graphics.print( self.char, self.x, self.y )
  --love.graphics.setColor(self.colour.r, self.colour.g, self.colour.b, self.colour.a)
--  love.graphics.rectangle("fill", self.x, self.y, self.size, self.size )
--  Square.super.draw(dt)
end

function BufferChar:setChar(char)
	self.char = char.char
	self.colour = char.colour
  self.bgcolour = char.bgcolour
end

return BufferChar
