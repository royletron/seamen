class = require '30log'

namegenerator = require 'namegenerator'

Crew = require 'entities.crew'

Ship = class ()
Ship.__name = 'Ship'
Ship.maxhealth = 0
Ship.health = 0
Ship.level = 1
Ship.exp = 0
Ship.money = 0
Ship.position = {}
Ship.ship = {name = ""}
Ship.crew = {}

local function randomFactor(ship)
  return ship.level * (math.random(0,2)/10)
end

function Ship:shoot(crew, target)
  local def = 0
  local eva = 0
  if rawget(getmetatable(target),'__name') == 'Baddie' then
    def = target.def
    eva = target.eva
  else
    local numdef = 0
    local numeva = 0
    for k,v in ipairs(target.crew) do
      if v.currentaction == defend then
        def = def + v.def
        numdef = numdef + 0.7
      end
      if v.currentaction == steer then
        eva = eva + v.eva
        numeva = numeva + 0.7
      end
    end
    def = def/numdef
    eva = eva/numeva
  end
  local atk = crew.atk + (crew.atk * self.level * 0.5)
  def = def + (def * target.level * 0.5)
  local acc = crew.acc + (crew.acc * self.level * 0.5)
  eva = eva + (eva * target.level * 0.5)
  print("atk ="..atk)
  print("def ="..def*randomFactor(target))
  print("acc ="..acc*randomFactor(self))
  print("eva ="..eva*randomFactor(target))
end

return Ship
