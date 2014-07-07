class = require '30log'
Ship = require 'entities.ship'

namegenerator = require 'namegenerator'

Crew = require 'entities.crew'

Player = Ship:extends{maxhealth = 100,
											health = 100,
											level = 1,
											exp = 0,
											money = 30,
											inventory = {{name = 'Bread', quantity = 10}},
											position = {},
											camera = {},
											ship = {},
											crew = {}}
Player.__name = 'Player'

function Player:__init()
	self.ship.name = namegenerator.pirateShipName()
  for i=1, math.random(3,5) do
    table.insert(self.crew, Crew())
  end
end

function Player:isSailing()
	return player.position.x == player.ship.x and player.position.y == player.ship.y
end

function Player:has(item)
	for k,v in ipairs(player.inventory) do
		if(v.name == item) then return v.quantity end
	end
	return 0
end

function Player:setInventory(item, number)
	local found = false
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
