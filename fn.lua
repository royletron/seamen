local fn = {}

function fn.map(f, list)
  local output = {}
  for i, v in ipairs(list) do
    output[i] = f(v, i)
  end
  return output
end

function fn.transpose(input)
  local output = {}

  for i = 1, #input[1] do
    output[i] = {}
    for j = 1, #input do
      output[i][j] = input[j][i]
    end
  end

  return output
end

function fn.sum(list)
  local output = 0
  for i, v in ipairs(list) do
    output = output + v
  end
  return output
end

function fn.weight(list)
  if type(list) ~= 'table' then
    return 1
  end
  return fn.sum(fn.map(fn.weight, list))
end

function fn.weighted_random(list)
  local value
  local count
  local index = 0
  for k, v in pairs(list) do
    if index == 0 then
      value = v
    else
      count = fn.weight(v)
      if math.random(0, index) < count then value = v end
    end
    index = index + 1
  end
  return value
end

function fn.random(list)
  return list[math.random(1, #list)]
end

function fn.try(list, ...)
  for i = 1, select('#', ...) do
    if list == nil then
      break
    end
    list = list[select(i, ...)]
  end
  return list
end

function fn.clamp(min, value, max)
  return math.max(min, math.min(max, value))
end

return fn