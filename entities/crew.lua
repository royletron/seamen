class = require '30log'

namegenerator = require 'namegenerator'

Crew = class ()
Crew.__name = 'Crew'

function Crew:__init(_tally)
  self.speed = math.random(50,80)/1000
  self.name=namegenerator.pirateName()
  self.level = 1
  self.exp = 0
  self.currentaction = 0
  local tally = 60
  if _tally ~= nil then tally = _tally end
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

-- Attempting get and set methods wish me luck

function Crew:__newindex(index, value)
  local f = false
  if index == "def" then self._def = value f = true end
  if index == "eva" then self._eva = value f = true end
  if index == "atk" then self._atk = value f = true end
  if index == "acc" then self._acc = value f = true end
  if f == false then rawset(self, index, value) end
end

function Crew:__index(index)
  if index == "def" then return self._def * self.level end
  if index == "eva" then return self._eva * self.level end
  if index == "atk" then return self._atk * self.level end
  if index == "acc" then return self._acc * self.level end
  return rawget(self, index)
end

function shuffled(tab)
  local n, order, res = #tab, {}, {}

  for i=1,n do order[i] = { rnd = math.random(), idx = i } end
  table.sort(order, function(a,b) return a.rnd < b.rnd end)
  for i=1,n do res[i] = tab[order[i].idx] end
  return res
end

return Crew
