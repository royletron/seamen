class = require '30log'
Town = class ()
Town.__name = 'Town'

names1 = {"Pen","Lough", "Stam", "Aber", "Acc", "Ex", "Ax", "Bre", "Cum", "Dun", "Fin", "Inver", "Kin", "Mon", "Nan", "Nant", "Pit", "Pol", "Pont", "Strath", "Tre", "Tilly", "Beck", "Canter", "Bath", "Liver", "Mal", "Ox", "Bletch", "Maccles", "Grim", "Wind", "Sher", "Gates", "Orp", "Brom", "Lewis", "Whit", "White", "Worm", "Tyne", "Avon", "Stan", "Wro", "Bo", "Ca", "Ch", "Bru", "Di", "Dra", "Ffa", "Fru", "Flu", "Garu", "Grun", "Hi", "Lo", "Mi", "Na", "P", "Pr", "Pl", "R", "S", "S", "Sl", "T", "Tr", "W" }
names2 = {"ville", "ham", "field", "ton", "town", "borough", "bridge", "bury", "wood", "ditch", "ford", "hall", "dean", "leigh", "dore", "ston", "stow", "church", "wich", "low", "way", "stone", "minster", "ley", "head", "bourne", "pool", "worth", "hill", "well", "hattan", "burg", "berg", "burgh", "port", "stoke", "haven", "stable", "stock", "side", "brook", "don", "den", "down", "nor", "grove", "combe", "by", "say", "ney", "chester", "dale", "ness", "shaw", "thwaite"}

function Town:__init()
	self.name = names1[math.random(1, #names1)] .. names2[math.random(1, #names2)]
end

return Town
