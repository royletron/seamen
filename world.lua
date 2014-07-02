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

require('perlin')

impassable = -1
water = 0
stone = 1
beach = 2
dirt = 3

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
      if terrain.value[r][c] == water then self:addChar(Char:new(r, c, '≋', Colour(44,151,149,255), Colour(50,169,167,255), water),'base') end
      if terrain.value[r][c] == stone then self:addChar(Char:new(r, c, '⍙', Colour(186,188,193,255), Colour(208,211,216,255), stone),'base') end
      if terrain.value[r][c] == beach then self:addChar(Char:new(r, c, '░', Colour(214,186,50,255), Colour(240,209,56,255), beach),'base') end
      if terrain.value[r][c] == dirt then self:addChar(Char:new(r, c, '⍋', Colour(170,182,34,255), Colour(191,204,39,255), dirt),'base') end
    end
  end
  print('drawn')
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
  return World
end

function World:getTowns(x,y,toX,toY)
	towns = {}
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
  if self.towndir[x] ~= nil then
    if self.towndir[x][y] ~= nil then
      return self.towndir[x][y]
    else
      return nil
    end
  else
    return nil
  end
end

function World:createTown(x, y)
  t = Char:new(x, y, '%', Colour(255,255,255,255), Colour(255,0,102,255), town)
  if self.towndir[x] == nil then self.towndir[x] = {} end
  self.towndir[x][y] = Town()
  self:addChar(t, 'towns')
end

function World:getBeachPoint()
  b = self:getRandomPoint()
  while b.type ~= beach do
    b = self:getRandomPoint()
  end
  return b
end

function World:getSpawnPoint()
  spawn = self:getRandomPoint()
  while spawn.type ~= water do
    spawn = self:getRandomPoint()
  end
  return spawn
end

function World:getRandomPoint(x1, x2, y1, y2)

  if x1 == nil then x1 = 1 end
  if x2 == nil then x2 = #self['base'] end
  if y1 == nil then y1 = 1 end
  if y2 == nil then y2 = #self['base'][x1] end

  randomx = math.random(1, #self['base'])
  randomy = math.random(1, #self['base'][randomx])
  return self['base'][randomx][randomy]
end

function World:getChar(x,y)
  if self['towns'] ~= nil then
    if self['towns'][x] ~= nil then
      if self['towns'][x][y] ~= nil then
        return self['towns'][x][y]
      end
    end
  end
  if self['monsters'] ~= nil then
    if self['monsters'][x] ~= nil then
      if self['monsters'][x][y] ~= nil then
        return self['monsters'][x][y]
      end
    end
  end
  if self['base'][x] == nil then
    return nil
  else
    if self['base'][x][y] == nil then
      return nil
    else
      return self['base'][x][y]
    end
  end
end

function World:addChar(char,layer)
  if self[layer] == nil then self[layer] = {} end
  if self[layer][char.x] == nil then self[layer][char.x] = {} end
  self[layer][char.x][char.y] = char
end

return World
