class = require '30log'
Player = class ()
Player.__name = 'Player'
Player.health = 100
Player.level = 1
Player.exp = 0
Player.position = {}

function Player:__init()
end


return Player
