local namegenerator = {}

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

function map(func, array)
  local new_array = {}
  for i,v in ipairs(array) do
    new_array[i] = func(v)
  end
  return new_array
end

function pick(list)
  local item = list[math.random(1, #list)] or ''
  if type(item) == 'table' then item = table.concat(map(pick, item), '') end
  return item
end

function namegenerator.pirateName()
  return pick(forenames) .. ' ' .. pick(surnames)
end

return namegenerator