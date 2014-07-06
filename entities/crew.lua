class = require '30log'

namegenerator = require 'namegenerator'

Crew = class ()
Crew.__name = 'Crew'

function Crew:__init()
  self.speed = math.random(5,10)/100
  self.name=namegenerator.pirateName()
  self.level = 1
  self.exp = 0
end

return Crew
