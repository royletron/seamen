forenames = {'Dave', 'Steve', 'Bill', 'Derick', 'Tony', 'Reginald', 'Graham', 'Norman', 'John', 'Guybrush'}
surnamePrefixes = {'Grog', 'Grey', 'Purple', 'Wench', 'Threep'}
surnameSuffixes = {' Beard', ' Lord', 'wood', 'boat'}

function pick(list)
  return list[math.random(1, #list)]
end

function pirateName()
  return pick(forenames) .. ' ' .. pick(surnamePrefixes) .. pick(surnameSuffixes)
end