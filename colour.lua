class = require '30log'
Colour = class ()
Colour.r, Colour.g, Colour.b, Colour.a = 255, 255, 255, 255

function Colour:__init(r, g, b, a)
  self.r, self.g, self.b, self.a = r, g, b, a
end

TRANSPARENT = Colour(0,0,0,0)
WHITE = Colour(255,255,255,255)
RED = Colour(255,0,0,255)
SALMON = Colour(255,0,102,255)
BLUE = Colour(44,151,149,255)
DARK_BLUE = Colour(50,169,167,255)
YELLOW = Colour(100,233,233,255)
TURQUOISE = Colour(164,133,81,0)
GRAY = Colour(100,100,100,255)

WATER_FG, WATER_BG = Colour(44,151,149,255), Colour(50,169,167,255)
ABYSS_FG, ABYSS_BG = Colour(100,233,161,255),  Colour(255,233,161,0)
SHIP_FG, SHIP_BG = Colour(184,149,91,255), Colour(164,133,81,255)
STONE_FG, STONE_BG = Colour(186,188,193,255), Colour(208,211,216,255)
BEACH_FG, BEACH_BG = Colour(214,186,50,255), Colour(240,209,56,255)
DIRT_FG, DIRT_BG = Colour(170,182,34,255), Colour(191,204,39,255)

return Colour