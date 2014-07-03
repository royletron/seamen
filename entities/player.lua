class = require '30log'
Player = class ()
Player.__name = 'Player'
Player.health = 100
Player.level = 1
Player.exp = 0
Player.money = 30
Player.inventory = {}
Player.position = {}

function Player:__init()

end

function Player:has(item)
	for k,v in ipairs(player.inventory) do
		if(v.name == item) then return v.quantity end
	end
	return 0
end

return Player
