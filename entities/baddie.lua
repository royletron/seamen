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
    self.setDestination(nil)
  else
    self:setDestination(fn.random(world.towncache))
  end

    -- str = ''
    -- for ix=1, #world.map do
    --   str = str .. 'r'
    --   for iy=1, #world.map[ix] do
    --     if (ix == self.x and iy == self.y) or (ix == self.destination.x and iy == self.destination.y) then
    --       str = str .. '\27[31mX\27[0m'
    --     else
    --       str = str .. world.map[ix][iy]
    --     end
    --   end
    --   str = str .. '\n'
    -- end
    -- print(str)

  self.statscrew = Crew(55)

  self.def = self.statscrew.def
  self.atk = self.statscrew.atk
  self.acc = self.statscrew.acc
  self.eva = self.statscrew.eva

  self.speed = math.random(50,110)/3000

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

function Baddie:__print()
  return 'Baddie(@' .. self.x .. ':' .. self.y .. ')'
end

function Baddie:setDestination(point)
  if point ~= nil then
    print('New heading for ' .. self:__print() .. ': ' .. self.x .. ":" .. self.y .. ' --> ' .. point.x .. ":" .. point.y)
    local path = world.pathfinder:getPath(self.x, self.y, point.x, point.y)
    if path ~= nil then
      self.destination = point
      self.path = {}
      for node, count in path:nodes() do
        table.insert(self.path, {x = node:getX(), y = node:getY()})
      end
    end
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
  local x, y = self.x, self.y

  if self.path ~= nil then
    local head = table.remove(self.path, 1)
    if head ~= nil then
      x = head.x
      y = head.y
    else
      self:setDestination(fn.random(world.towncache))
    end
    -- if self.x < self.destination.x then x = 1 end
    -- if self.x > self.destination.x then x = -1 end
    -- if self.y > self.destination.y then y = -1 end
    -- if self.y < self.destination.y then y = 1 end
  else
    local direction = math.random(1,4)
    if direction == 1 then x = x + 1 end
    if direction == 2 then x = x -1 end
    if direction == 3 then y = y + 1 end
    if direction == 4 then y = y - 1 end
  end

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
  -- for k,v in ipairs(baddies) do
  --   if v.x == x and v.y == y then collide = true break end
  -- end
  if x == player.x and y == player.y then
    FightState.baddie = self
    Gamestate.switch(FightState)
  end
  if collide == false and tile ~= nil and tile.char == '≋' then
    table.insert(world.waves, {x=self.x, y=self.y, ttl=0.5})
    self.x, self.y = x, y
  end
end

return Baddie
