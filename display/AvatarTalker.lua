Sprite = require 'Sprite'
AvatarTalker = Sprite:extends{}
AvatarTalker.__name = 'AvatarTalker'
AsciiSprite = require('ascii.ascii_sprite')
Renderer = require('renderer')
AsciiRenderer = require('ascii.ascii_renderer')

function AvatarTalker:__init(x,y,w, initialmessage, textcolour, avatar, talkingavatar)
	self.x, self.y, self.w = x,y,w
	if avatar ~= nil then
		self.renderer = Renderer(x, y, 28, 20,label_font,char_font)
		self.avatar = AsciiSprite(avatar)
		self.renderer:setAscii(self.avatar)
	end
	self.message = initialmessage
	self.textcolour = textcolour
	self.letters = 0
	self.elapsed = 0
	self.framerate = 20
	self.currenttime = 0
end

function AvatarTalker:draw(dt)
  love.graphics.setColor(self.textcolour.r, self.textcolour.g, self.textcolour.b, self.textcolour.a)
  love.graphics.setFont(pirate_font);
	love.graphics.printf(self.message:sub(1, self.letters), self.x, self.y, self.w)
	if self.renderer ~= nil then
    self.renderer:draw(dt)
  end
end

function AvatarTalker:update(dt)
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