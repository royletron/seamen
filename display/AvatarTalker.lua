Sprite = require 'Sprite'
AvatarTalker = Sprite:extends{}
AvatarTalker.__name = 'AvatarTalker'

function AvatarTalker:__init(x,y,w, initialmessage, textcolour, avatar, talkingavatar)
	self.x, self.y, self.w = x,y,w
	self.avatar = avatar
	self.message = initialmessage
	self.talkingavatar = talkingavatar
	self.textcolour = textcolour
	self.letters = 0
	self.elapsed = 0
	self.framerate = 20
	self.currenttime = 0
end

function AvatarTalker:draw(dt)
  love.graphics.setColor(self.textcolour.r, self.textcolour.g, self.textcolour.b, self.textcolour.a)
  love.graphics.setFont(char_font);
	love.graphics.printf(self.message:sub(1, self.letters), self.x, self.y, self.w)
end

function AvatarTalker:update(dt)
	self.currenttime = self.currenttime + dt
	if self.currenttime > (1 / self.framerate) then
		self.elapsed = self.elapsed + 1
  	self.letters=math.min(math.floor(self.elapsed), #self.message)
  	self.currenttime = 0
  end
end

return AvatarTalker