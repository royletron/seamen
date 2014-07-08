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
  return ship.level * (math.random(100,150)/100)
end

function Ship:shoot(crew, target)
  local def = 0
  local eva = 0
  local player = true
  local result = {hit = false, value = 0}
  if rawget(getmetatable(target),'__name') == 'Baddie' then
    player = false
    def = target.def/3
    eva = target.eva/3
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
  local atk = (crew.atk + (crew.atk * self.level * 0.4))
  def = (def + (def * target.level * 0.2))
  local acc = (crew.acc + (crew.acc * self.level * 0.4))
  eva = (eva + (eva * target.level * 0.2))
  if acc*randomFactor(self) > eva*randomFactor(target) then
    result.hit = true
  else
    if player == true then
      result.hit = math.random(1,10) > 6
    else
      result.hit = math.random(1,10) > 7
    end
  end

  local attack = atk*randomFactor(self) - def*randomFactor(target)
  if attack < (atk/2) then
    result.value = atk/2
  else
    result.value = atk
  end

  return result
  --print("atk ="..atk*randomFactor(self))
  --print("def ="..def*randomFactor(target))
  --print("acc ="..acc*randomFactor(self))
  --print("eva ="..eva*randomFactor(target))
end

return Ship
