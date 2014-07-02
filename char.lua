class = require '30log'
Colour = require 'colour'
Char = class ()
Char.__name = 'Char'
Char.x, Char.y = 0, 0
Char.col = Colour(255,255,255,255)
Char.type = -1

function Char:__init(x,y,char,colour,bgcolour,type)
  self.x, self.y, self.char, self.colour, self.type = x,y,char,colour,type
  self.bgcolour = bgcolour
end

return Char
