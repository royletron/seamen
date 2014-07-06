local namegenerator = {}

fn = require('fn')

PIRATE_NAMES = {{
  'Morgan',
  'Isabela',
  'Killian',
  'Jesamiah',
  'Jezebel',
  'Drongo',
  'Seth',
  'Hector',
  {{'Mad ', 'Rusty ', ''}, {'Jack', 'Pete'}},
  'Black John',
  'Billy',
  'Nico',
  'Brook',
  'Dutch',
  'Roronoa',
  'Christopher',
  'John',
  'Joan',
  'Elizabeth',
  'Elaine',
  'Murdoch',
  'Robinson',
  'Ridley',
  'Russel',
  'Red',
  'Canus',
  'Romulus',
  'William',
  'Guybrush'
}, {
  'Threepwood',
  'Bones',
  'Silver',
  'Swann',
  'Turner',
  'Law',
  'Clegg',
  {{'Iron', 'Meat'}, {'hook', 'hand'}},
  'Harlock',
  'Roscoe',
  'Crook',
  'Barbosa',
  'Crow',
  'Corsair',
  'Roberts',
  'Slag',
  'Swabb',
  'Grog',
  'Ramsey',
  'Faber',
  'Flint',
  'Gutt',
  'Drift',
  'Benett',
  'Kennit',
  'Loveheart',
  {{'de '}, {'Berry', 'Leon'}},
  {{'Von ', ''}, {'Carrigan', 'Avery', 'Kenway'}},
  {{'Dark', 'Grey', 'Black', 'Skunk', 'Red', 'Crimson'}, {'beard', 'heart', 'eye'}},
  {{'Scurvy ', 'Evil ', 'Rancid ', 'Dank-'}, {'Dog', 'Rat', 'Weavil'}}
}}

PIRATE_SHIP_NAMES = {
  {{'Jolly'}, {' Roger', ' Princess', ' Sailor'}},
  {{'Black', 'The'}, {' Pearl', ' Hawk', ' Swan'}},
  'The Siren',
  'The Trident'
}

function pick(list)
  local item = fn.weighted_random(list) or ''
  if type(item) == 'table' then item = table.concat(fn.map(pick, item), '') end
  return item
end

function namegenerator.pirateName()
  return table.concat(fn.map(pick, PIRATE_NAMES), ' ')
end

function namegenerator.pirateShipName()
  return pick(PIRATE_SHIP_NAMES)
end

return namegenerator