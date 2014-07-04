local namegenerator = {}

fn = require('fn')

forenames = {
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
}
surnames = {
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
}

function pick(list)
  local item = fn.random(list) or ''
  if type(item) == 'table' then item = table.concat(fn.map(pick, item), '') end
  return item
end

function namegenerator.pirateName()
  return pick(forenames) .. ' ' .. pick(surnames)
end

return namegenerator