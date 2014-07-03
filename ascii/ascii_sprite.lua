class = require '30log'
AsciiSprite = class ()
BufferChar = require 'BufferChar'
Colour = require 'Colour'

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
  for fk, fv in ipairs(raw) do
    self.maxframe = fk
    ascii = fv
    if #fv > self.h then self.h = #fv end
    self.frames[fk] = {}
    for k,v in ipairs(ascii) do
      if string.len(v) > self.w then self.w = string.len(v) end
      for i = 1, #v do
        local c = v:sub(i,i)
        if self.frames[fk][i] == nil then self.frames[fk][i] = {} end
        self.frames[fk][i][k] = c
      end
    end
  end
end

function AsciiSprite:getFrame(dt)
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