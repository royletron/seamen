class = require '30log'

namegenerator = require 'namegenerator'

Crew = class ()
Crew.__name = 'Crew'

function Crew:__init()
  self.speed = math.random(5,100)/1000
  self.name=namegenerator.pirateName()
  self.level = 1
  self.exp = 0
  self.def = 0
  self.eva = 0
  self.atk = 0
  self.acc = 0
  local tally = 60
  for k, v in ipairs(shuffled{1,2,3,4,self.def, self.eva, self.atk, self.acc}) do
    v = math.random(1, math.min(20, tally))
    tally = tally - v
  end
end

function shuffled(tab)
  local n, order, res = #tab, {}, {}

  for i=1,n do order[i] = { rnd = math.random(), idx = i } end
  table.sort(order, function(a,b) return a.rnd < b.rnd end)
  for i=1,n do res[i] = tab[order[i].idx] end
  return res
end

return Crew
