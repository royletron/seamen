class = require '30log'
Colour = class ()
Colour.r, Colour.g, Colour.b, Colour.a = 255, 255, 255, 255

function Colour:__init(r, g, b, a)
  self.r, self.g, self.b, self.a = r, g, b, a
end

return Colour