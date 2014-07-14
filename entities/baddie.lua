class = require '30log'
Ship = require 'entities.ship'

namegenerator = require 'namegenerator'

Baddie = Ship:extends{}
Baddie.__name = 'Baddie'

function Baddie:__init(x, y)
  self.x, self.y = x,y
  self.ship.name = namegenerator.pirateShipName()
  self.counter = 0
  self.mapspeed = math.random(1,3)
  self.level = math.random(math.max(player.level-2, 1), player.level+2)
  self.is_ghost = love.math.random() > 0.9
  if self.is_ghost then
    self.destination = nil
  else
    self.destination = fn.random(world.towncache)
  end
  if self.destination ~= nil then
    print(self.x .. ":" .. self.y)
    print(self.destination.x .. ":" .. self.destination.y)
    self.path = world.pathfinder:getPath(self.x, self.y, self.destination.x, self.destination.y)
    print(self.path)
  end

  local statscrew = Crew(55)

  self.def = statscrew.def
  self.atk = statscrew.atk
  self.acc = statscrew.acc
  self.eva = statscrew.eva
  self.speed = statscrew.speed

  self.ascii = SHIP_CLIPPER
  self.health = (40 * self.level) + ((math.random(1,2) * math.ceil(self.level/10)) * 10)
  self.maxhealth = self.health
  if self.is_ghost then
    self.foreground = Colour(255, 255, 255, 255)
    self.background = Colour(200, 200, 200, 225)
  else
    self.foreground = Colour(math.max(20, (100 + ((self.level-player.level) * 50))),20,20,255)
    self.background = Colour(math.max(80, (100 + ((self.level-player.level) * 50))),80,80,255)
  end
end


function Baddie:__index(index)
  if index == "alive" then print(self.health) return self.health > 0 end
  return rawget(self, index)
end

function Baddie:update(dt)
  self.counter = self.counter + dt
  if self.counter > self.mapspeed then
    self:move()
    self.counter = 0
  end
end

function Baddie:move()
  local x, y = 0, 0

  if self.path ~= nil then
    -- if self.x < self.destination.x then x = 1 end
    -- if self.x > self.destination.x then x = -1 end
    -- if self.y > self.destination.y then y = -1 end
    -- if self.y < self.destination.y then y = 1 end
  else
    local direction = math.random(1,4)
    if direction == 1 then x = 1 end
    if direction == 2 then x = -1 end
    if direction == 3 then y = 1 end
    if direction == 4 then y = -1 end
  end

  x = self.x + x
  y = self.y + y

  local tile = fn.try(world['base'], x, y)

  self:goto(x, y)
  -- local direction = math.random(1,4)
  -- if direction == 1 then self:goto(self.x + 1, self.y) end
  -- if direction == 2 then self:goto(self.x - 1, self.y) end
  -- if direction == 3 then self:goto(self.x, self.y + 1) end
  -- if direction == 4 then self:goto(self.x, self.y - 1) end
end

function Baddie:goto(x, y)
  local tile = fn.try(world['base'], x, y)
  local collide = false
  for k,v in ipairs(baddies) do
    if v.x == x and v.y == y then collide = true break end
  end
  if collide == false and tile ~= nil and tile.type == water then self.x, self.y = x, y end
end

return Baddie
