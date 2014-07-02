class = require '30log'
Town = class ()
Town.__name = 'Town'

local characters = {'=', ':', "H", "I", "M"}
local badge = { ' -----','------ ',
								'|     ','      |',
 							 '|   ',     '   |',
							  '|   ',     '   |',
								'|   ',     '   |',
								'|   ',     '   |',
								':   ',     '   ;',
								'\\   ',    '   / ',
								' \\    ','     / ',
								'  `.   ','  ,\' ',
								'    `.',' ,\' ',
								'      ','+ '}

names1 = {"Pen","Lough", "Stam", "Aber", "Acc", "Ex", "Ax", "Bre", "Cum", "Dun", "Fin", "Inver", "Kin", "Mon", "Nan", "Nant", "Pit", "Pol", "Pont", "Strath", "Tre", "Tilly", "Beck", "Canter", "Bath", "Liver", "Mal", "Ox", "Bletch", "Maccles", "Grim", "Wind", "Sher", "Gates", "Orp", "Brom", "Lewis", "Whit", "White", "Worm", "Tyne", "Avon", "Stan", "Wro", "Bo", "Ca", "Ch", "Bru", "Di", "Dra", "Ffa", "Fru", "Flu", "Garu", "Grun", "Hi", "Lo", "Mi", "Na", "P", "Pr", "Pl", "R", "S", "S", "Sl", "T", "Tr", "W" }
names2 = {"ville", "ham", "field", "ton", "town", "borough", "bridge", "bury", "wood", "ditch", "ford", "hall", "dean", "leigh", "dore", "ston", "stow", "church", "wich", "low", "way", "stone", "minster", "ley", "head", "bourne", "pool", "worth", "hill", "well", "hattan", "burg", "berg", "burgh", "port", "stoke", "haven", "stable", "stock", "side", "brook", "don", "den", "down", "nor", "grove", "combe", "by", "say", "ney", "chester", "dale", "ness", "shaw", "thwaite"}

function Town:__init()
	self.name = names1[math.random(1, #names1)] .. names2[math.random(1, #names2)]
	self:generateCrest()
	self.supplies = {}
	for k,v in ipairs(supplies) do
		table.insert(self.supplies, {name = v.name, cost = math.random(v.min, v.max), stock = math.random(v.minnum, v.maxnum)})
	end
end

function Town:generateCrest()
	self.crest = {badge[1]..badge[2], badge[3]..badge[4]}
	bl = 1
	for v=1, 6, 1 do
		l = ''
		for b=1, 3, 1 do
			b = math.random(1,10)
			c = " "
			if b > 3 then c = characters[math.random(1, #characters)] end
			l = l .. c
		end
		l = l .. l:sub(2,2) .. l:sub(1,1)
		bl = ((v+2)*2)-1
		table.insert(self.crest, badge[bl] .. l .. badge[bl+1])
	end
	bl = bl + 2
	for a=bl, #badge, 2 do
		table.insert(self.crest, badge[a] .. badge[a+1])
	end
end

return Town
