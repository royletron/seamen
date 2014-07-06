class = require '30log'

namegenerator = require 'namegenerator'

Crew = class ()
Crew.__name = 'Crew'

function Crew:__init()
  self.speed = math.random(50,80)/1000
  self.name=namegenerator.pirateName()
  self.level = 1
  self.exp = 0
  self.currentaction = 0
  local tally = 60
  local randomvars = {}
  for i=1, 4, 1 do
    local v = math.random(1, math.min(20, tally))
    tally = tally - v
    table.insert(randomvars, v)
  end

  self.def = randomvars[1]
  self.eva = randomvars[2]
  self.atk = randomvars[3]
  self.acc = randomvars[4]
end

function shuffled(tab)
  local n, order, res = #tab, {}, {}

  for i=1,n do order[i] = { rnd = math.random(), idx = i } end
  table.sort(order, function(a,b) return a.rnd < b.rnd end)
  for i=1,n do res[i] = tab[order[i].idx] end
  return res
end

return Crew
