class = require '30log'
Player = class ()
Player.__name = 'Player'
Player.health = 100
Player.level = 1
Player.exp = 0
Player.money = 30
Player.inventory = {{name = 'Bread', quantity = 10}}
Player.position = {}

function Player:__init()

end

function Player:has(item)
	for k,v in ipairs(player.inventory) do
		if(v.name == item) then return v.quantity end
	end
	return 0
end

function Player:setInventory(item, number)
	found = false
	for k,v in ipairs(self.inventory) do
		if(v.name == item) then 
			found = true
			v.quantity = v.quantity + number 
		end
	end
	if found == false then
		table.insert(self.inventory, {name= item, quantity = number})
	end
end

return Player
