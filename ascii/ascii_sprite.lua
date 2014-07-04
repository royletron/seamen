class = require '30log'
AsciiSprite = class ()
BufferChar = require 'BufferChar'
Colour = require 'Colour'
utf8 = require 'utf8'

function AsciiSprite:__init(raw)
	self.w = 0
  self.h = 0
  self.x = raw.x
  self.y = raw.y
  if self.x == nil then self.x = 0 end
  if self.y == nil then self.y = 0 end
  self.framerate = 8
  self.frames = {}
  self.counter = self.framerate + 1
  self.currentframe = 1
  self.maxframe = 1
  if raw.framerate ~= nil then self.framerate = raw.framerate end
	if raw.colour == nil then self.colour = Colour(100,233,233,255) else self.colour = raw.colour end
	if raw.bgcolour == nil then self.bgcolour = Colour(164,133,81,0) else self.bgcolour = raw.bgcolour end
  for fk, fv in ipairs(raw) do
    self.maxframe = fk
    ascii = fv
    if #fv > self.h then self.h = #fv end
    self.frames[fk] = {}
    for k,v in ipairs(ascii) do
      local max = utf8.len(v)
      if max > self.w then self.w = max end
      for i = 1, max do
        local c = utf8.sub(v, i,i)
        if self.frames[fk][i] == nil then self.frames[fk][i] = {} end
				char = Char:new(i,k,c, self.colour, self.bgcolour)
        self.frames[fk][i][k] = char
      end
    end
  end
end

function AsciiSprite:getFrame(dt)
  if self.framerate == 0 then return self.frames[self.currentframe] end
  self.counter = self.counter + dt
  if self.counter > (1 / self.framerate) then
    self.counter = 0
    self.currentframe = self.currentframe + 1
    if self.currentframe > self.maxframe then self.currentframe = 1 end
  end
  return self.frames[self.currentframe]
end

function split(str, delim)
    local result,pat,lastPos = {},"(.-)" .. delim .. "()",1
    for part, pos in string.gfind(str, pat) do
        table.insert(result, part); lastPos = pos
    end
    table.insert(result, string.sub(str, lastPos))
    return result
end

return AsciiSprite
