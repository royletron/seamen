class = require '30log'
InfoPanel = class ()
InfoPanel.__name = 'InfoPanel'

function InfoPanel:__init(x,y)
	self.x, self.y = x,y
end

function InfoPanel:draw(dt)
	if player ~= nil then
	  love.graphics.setColor(127,175,27,255)
  	love.graphics.setFont(info_font)
  	love.graphics.print('⚔', self.x, self.y)
  	love.graphics.setFont(char_font)
  	love.graphics.print(player.level, self.x+17, self.y+8)

	  love.graphics.setColor(0,180,255,255)
  	love.graphics.setFont(info_font)
  	love.graphics.print('⍟', self.x+50, self.y+2)
  	love.graphics.setFont(char_font)
  	love.graphics.print(player.exp, self.x+67, self.y+8)

	  love.graphics.setColor(255,204,0,255)
  	love.graphics.setFont(info_font)
  	love.graphics.print('◉', self.x+100, self.y)
  	love.graphics.setFont(char_font)
  	love.graphics.print(player.money, self.x+117, self.y+8)
  end
end

function InfoPanel:update(dt)

end

return InfoPanel