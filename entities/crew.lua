class = require '30log'

namegenerator = require 'namegenerator'

Crew = class ()
Crew.__name = 'Crew'
Crew.level = 1
Crew.exp = 0

function Crew:__init()
  self.name=namegenerator.pirateName()
end

return Crew
