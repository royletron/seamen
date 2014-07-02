Sprite = require 'Sprite'
BufferChar = require 'BufferChar'
Colour = require 'Colour'
Label = require 'world.label'
require 'World'
Renderer = Sprite:extends{size = 0}

function Renderer:__init(x,y,w,h,label_font,char_font)

  self.x,self.y,self.w,self.h = x,y,w,h

	self.stage = Sprite()

  self.char_font, self.label_font = char_font, label_font

	self.buffer = {}
  self.labels = {}

  self.ascii = nil

  --self.stage:add(Label(10,10,Colour(100,255,255,255), Colour(100,100,100,255), 'Hello', self.label_font))

	-- create the buffer with dummy chars
	for _x=0, w, 1 do
		for _y=0, h, 1 do
			if self.buffer[_x] == nil then self.buffer[_x] = {} end
			bufferchar = BufferChar(self.x + TILE_W*_x, self.y + TILE_H*_y, ' ', Colour(0,0,0,0), Colour(0,0,0,0), self.char_font)
			self.stage:add(bufferchar)
			self.buffer[_x][_y] = bufferchar
		end
	end
end

function Renderer:drawChar(x, y, char)
  	if self.buffer[x] == nil then
		print('x:'+x+' is out of bounds')
	else
		if self.buffer[x][y] == nil then
			print('y:'+y+' is out of bounds')
		else
			self.buffer[x][y]:setChar(char)
		end
	end
end

function Renderer:setAscii(ascii)
  self.ascii = ascii
  -- for x, vx in ipairs(ascii.buffer) do
  --   print(#vx)
  --   for y, vy in ipairs(vx) do
  --     char = Char:new(x,y,vy, Colour(100,233,233,255), Colour(164,133,81,0))
  --     self:drawChar(x,y,char)
  --   end
  -- end
end

function Renderer:drawAscii(dt)
  frame = self.ascii:getFrame(dt)
  if frame ~= nil then
    for x=1, #frame, 1 do
      if frame[x] ~= nil then
        for y=1, #frame[x], 1 do
          if frame[x][y] ~= nil then
            char = Char:new(x,y,frame[x][y], Colour(100,233,233,255), Colour(164,133,81,0))
            self:drawChar(x,y,char)
          end
        end
      end
    end
  end
end

function Renderer:clearLabels()
  self.labels = {}
end

function Renderer:addLabel(label)
  table.insert(self.labels, label)
end

function Renderer:update(dt)
  if self.ascii ~= nil then self:drawAscii(dt) end
  self.stage:update(dt)
end

function Renderer:draw(dt)
  self.stage:draw(dt)

  for k,v in ipairs(self.labels) do
    v:draw(dt)
  end
end

return Renderer
