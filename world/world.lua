-----------------------------------------------------------------------------------------
--
-- world.lua
--
-----------------------------------------------------------------------------------------

class = require '30log'
World = class ()
World.__name = 'World'
Char = require('char')
Town = require('town')

World.year = nil
World.date = nil

local Grid = require ("jumper.grid") -- The grid class
local Pathfinder = require ("jumper.pathfinder") -- The pathfinder lass

require('perlin')
fn = require('fn')

function rand(seed, n)
  if n <= 0 then return nil end
  if seed ~= mySeed or lastN < 0 or n <= lastN then
    mySeed = seed
    math.randomseed(seed)
    lastN = 0
  end
  while lastN < n do
    num = math.random()
    lastN = lastN + 1
  end
  return num - 0.5
end

function World:__init(w,h)
  -- rooms = {}
  -- for a = 0, 9000, 1 do
  --   room = Room:new({x = math.random(1, 260),y = math.random(1, 262),w = math.random(3, 15),h = math.random(3, 15)})
  --   failed = false
  --   for k,v in ipairs(rooms) do
  --     if v:intersects(room) then
  --       failed = true
  --       break
  --     end
  --   end
  --   if failed then
  --     room:destroy()
  --   else
  --     table.insert(rooms, room)
  --     room:draw(self)
  --     -- if #rooms ~= 0 then
  --     --   prevroom = rooms[1]
  --     --   print(prevroom)
  --     --   corridor = Corridor:new({x1 = room.center.x, x2 = prevroom.center.x, y1 = room.center.y, y2= prevroom.center.y })
  --     -- end
  --   end
  -- end

  terrain = {}
  if seed == nil then seed = os.time() end
  terrain.seed = seed
  terrain.perlin = perlin2D(seed, w, h, 0.55, 7, 4.5)
  print('terrain')
  terrain.value = {}

  self.towndir = {}

  self.land = {}
  self.beach = {}
  self.water = {}
  self.towncache = {}

  for r = 1, #terrain.perlin do
    terrain.value[r] = {}
    dirtMargin = (200-r) * 0.01
    for c = 1, #(terrain.perlin[r]) do
      value = terrain.perlin[r][c]
      if value > 0.05 then terrain.value[r][c] = water
      elseif value > 4.5 - dirtMargin or value < -1 then terrain.value[r][c] = stone
      elseif value < -0.3 then terrain.value[r][c] = dirt
      else terrain.value[r][c] = beach
      end
    end
  end
  print('valued')
  for r = 1, #terrain.value do
    for c = 1, #(terrain.value[1]) do
      local tile = terrain.value[r][c]

      if tile == stone or tile == dirt then table.insert(self.land, {r, c})
      elseif tile == beach then table.insert(self.beach, {r, c})
      elseif tile == water then table.insert(self.water, {r, c}) end

      if tile == water then self:addChar(Char:new(r, c, '≋', Colour(44,151,149,255), Colour(50,169,167,255), water),'base')
      elseif tile == stone then self:addChar(Char:new(r, c, '⍙', Colour(186,188,193,255), Colour(208,211,216,255), stone),'base')
      elseif tile == beach then self:addChar(Char:new(r, c, '░', Colour(214,186,50,255), Colour(240,209,56,255), beach),'base')
      elseif tile == dirt then self:addChar(Char:new(r, c, '⍋', Colour(170,182,34,255), Colour(191,204,39,255), dirt),'base') end
    end
  end
  print('drawn')
  for n = 1, 100 do
    self:createTreasure(unpack(fn.random(self.land)))
  end
  for t = 1, 100, 1 do
    p = self:getBeachPoint()
    d = math.random(1, 4)
    skip = false
    while p.type ~= water do
      if p.x == 1 or p.x == #self['base'] or p.y == 1 or p.y == #self['base'][2] then
        skip = true
        break
      end
      if d == 1 then p = self['base'][p.x-1][p.y]
      elseif d == 2 then p = self['base'][p.x+1][p.y]
      elseif d == 3 then p = self['base'][p.x][p.y-1]
      else p = self['base'][p.x][p.y+1]
      end
    end
    if skip == false then
      if d == 1 then p = self['base'][p.x+1][p.y]
      elseif d == 2 then p = self['base'][p.x-1][p.y]
      elseif d == 3 then p = self['base'][p.x][p.y+1]
      else p = self['base'][p.x][p.y-1]
      end
      self:createTown(p.x, p.y)
    end
  end
  print('towned')

  self.date = os.time{year=2014, month=math.random(1, 12), day=math.random(1, 31), hour=math.random(1, 23)}
  self.year = 1650

  local map = fn.map(function(col)
    return fn.map(function(row)
      return row.type
    end, col)
  end, self['base'])

  self.one_and_zero_grid = map
  self.basegrid = Grid(map)
  self.pathfinder = Pathfinder(self.basegrid, 'ASTAR', water)

  return World
end

function World:getTowns(x,y,toX,toY)
	local towns = {}
	for _x = x, toX, 1 do
		if self.towndir[_x] ~= nil then
			for _y = y, toY, 1 do
				if self.towndir[_x][_y] ~= nil then
					table.insert(towns, {town=self.towndir[_x][_y], x=_x, y=_y})
				end
			end
		end
	end
	return towns
end

function World:getTown(x,y)
  return fn.try(self.towndir, x, y)
end

function World:createTreasure(x, y)
  local tile = fn.try(self['base'], x, y)
  self:addChar(Char:new(x, y, 'X', Colour(255,0,0,255), tile.bgcolour, treasure), 'treasure')
end

function World:createTown(x, y)
  table.insert(self.towncache, {x=x, y=y})
  t = Char:new(x, y, '%', Colour(255,255,255,255), Colour(255,0,102,255), town)
  if self.towndir[x] == nil then self.towndir[x] = {} end
  self.towndir[x][y] = Town()
  self:addChar(t, 'towns')
end

function World:getBaseChar(x, y)
  return self['base'][x][y]
end

function World:getBeachPoint()
  return self:getBaseChar(unpack(fn.random(self.beach)))
end

function World:getSpawnPoint()
   return self:getBaseChar(unpack(fn.random(self.water)))
end

function World:getTreasurePoint()
  return self:getBaseChar(unpack(fn.random(self.land)))
end

function World:getChar(x,y)
  return (
    fn.try(self['towns'], x, y) or
    fn.try(self['monsters'], x, y) or
    fn.try(self['treasure'], x, y) or
    fn.try(self['base'], x, y)
  )
end

function World:addChar(char,layer)
  if self[layer] == nil then self[layer] = {} end
  if self[layer][char.x] == nil then self[layer][char.x] = {} end
  self[layer][char.x][char.y] = char
end

return World
