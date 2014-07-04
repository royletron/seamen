class = require '30log'

namegenerator = require 'namegenerator'

Player = class ()
Player.__name = 'Player'
Player.health = 100
Player.level = 1
Player.exp = 0
Player.money = 30
Player.inventory = {{name = 'Bread', quantity = 10}}
Player.position = {}
Player.crew = {}

function Player:__init()
  for i=1, 4 do
    table.insert(self.crew, {name=namegenerator.pirateName()})
  end
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
