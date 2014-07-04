Sprite = require 'display.Sprite'
AvatarTalker = Sprite:extends{}
AvatarTalker.__name = 'AvatarTalker'
AsciiSprite = require('ascii.ascii_sprite')
Renderer = require('display.renderer')
AsciiRenderer = require('ascii.ascii_renderer')

function AvatarTalker:__init(x,y,w, initialmessage, textcolour, staticavatar, talkingavatar)
	self.x, self.y, self.w = x,y,w
	self.staticavatar, self.talkingavatar = staticavatar, talkingavatar
	if staticavatar ~= nil then
		self.staticavatar = AsciiSprite(staticavatar)
		self.renderer = Renderer(x, y, 28, 20,label_font,char_font)
		self.avatar = AsciiRenderer()
		self.avatar:add(self.staticavatar)
		self.renderer:setAscii(self.avatar)
	end
	if self.talkingavatar ~= nil then self.talkingavatar = AsciiSprite(talkingavatar) end
	self.message = initialmessage
	self.textcolour = textcolour
	self.letters = 0
	self.elapsed = 0
	self.framerate = 20
	self.currenttime = 0
end

function AvatarTalker:draw(dt)
  love.graphics.setColor(self.textcolour.r, self.textcolour.g, self.textcolour.b, self.textcolour.a)
  love.graphics.setFont(pirate_font_small);
	love.graphics.printf(self.message:sub(1, self.letters), self.x+120, self.y+50, self.w-70)
	if self.renderer ~= nil then
    self.renderer:draw(dt)
  end
end

function AvatarTalker:talking()
	return self.elapsed < #self.message
end

function AvatarTalker:update(dt)
	if self.talkingavatar ~= nil then
		if self:talking() then
			if self.avatar:contains(self.talkingavatar) == false then
				self.avatar:add(self.talkingavatar)
			end
		else
			if self.avatar:contains(self.talkingavatar) == true then
				self.avatar:remove(self.talkingavatar)
			end
		end
	end
	self.currenttime = self.currenttime + dt
	if self.currenttime > (1 / self.framerate) then
		self.elapsed = self.elapsed + 1
  	self.letters=math.min(math.floor(self.elapsed), #self.message)
  	self.currenttime = 0
  end
  if self.renderer ~= nil then
    self.renderer:update(dt)
  end
end

function AvatarTalker:setText(text)
	self.message = text
	self.letters = 0
	self.elapsed = 0
end

return AvatarTalker
