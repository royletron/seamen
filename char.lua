class = require '30log'
Colour = require 'colour'
Char = class ()
Char.__name = 'Char'
Char.x, Char.y = 0, 0
Char.col = Colour(255,255,255,255)
Char.type = -1

function Char:__init(x,y,char,colour,bgcolour,type)
  if colour == nil then
    error()
  end
  if bgcolour == nil then
    error()
  end
  self.x = x
  self.y = y
  self.char = char
  self.colour = colour
  self.bgcolour = bgcolour
end

return Char
