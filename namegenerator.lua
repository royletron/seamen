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
  {{'Mad', 'Rusty', ''}, {'Jack', 'Pete'}},
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
  'Ironhook',
  'Harlock',
  'Roscoe',
  'Crook',
  'Crow',
  'Corsair',
  'Roberts',
  'Slag',
  'Grog',
  'Ramsey',
  'Faber',
  'Flint',
  'Gutt',
  'Drift',
  'Benett',
  'Kennit',
  {{'de'}, {'Berry', 'Leon'}},
  {{'Von ', ''}, {'Carrigan', 'Avery', 'Kenway'}},
  {{'Grey', 'Black', 'Skunk', 'Crimson'}, {'beard', 'heart', 'eye'}},
}

function pick(list)
  local item = list[math.random(1, #list)] or ''
  if type(item) == 'table' then item = pick(item[1]) .. pick(item[2]) end
  return item
end

function namegenerator.pirateName()
  return pick(forenames) .. ' ' .. pick(surnames)
end

return namegenerator