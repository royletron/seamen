class = require '30log'
AsciiRenderer = class ()
BufferChar = require 'BufferChar'
Colour = require 'Colour'
Label = require 'world.label'

function AsciiRenderer:__init()
  self.layers = {}
end

function AsciiRenderer:add(sprite)
  table.insert(self.layers, sprite)
end

function AsciiRenderer:contains(sprite)
  for k,v in ipairs(self.layers) do
    if v == sprite then return true end
  end
  return false
end

function AsciiRenderer:remove(sprite)
  for k,v in ipairs(self.layers) do
    if v == sprite then
      table.remove(self.layers, k)
    end
  end
end

function AsciiRenderer:getFrame(dt)
  buffer = {}
  if self.layers[0] ~= nil then root = self.layers[1]:getFrame(dt) end
  for k, s in ipairs(self.layers) do
    if #buffer == 0 then
      buffer = table.shallow_copy_2d(s:getFrame(dt))
    else
      frame = s:getFrame(dt)
      if frame ~= nil then
        for x=1, #frame, 1 do
          if frame[x] ~= nil then
            for y=1, #frame[x], 1 do
              if frame[x][y] ~= nil then
                if buffer[x + s.x] ~= nil then
                  if buffer[x + s.x][y + s.y] ~= nil then
                    if frame[x][y] ~= ' ' then
                      buffer[x + s.x][y + s.y] = frame[x][y]
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  return buffer
end

function table.shallow_copy_2d(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = table.shallow_copy(v)
  end
  return t2
end

function table.shallow_copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end

return AsciiRenderer
