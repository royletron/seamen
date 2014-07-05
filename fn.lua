local fn = {}

function fn.random(list)
  return list[math.random(1, #list)]
end

function fn.map(f, list)
  local output = {}
  for i, v in ipairs(list) do
    output[i] = f(v)
  end
  return output
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