class = require '30log'

namegenerator = require 'namegenerator'

Baddie = class ()
Baddie.__name = 'Baddie'

function Baddie:__init(x, y)
  self.x, self.y = x,y
end

return Baddie
