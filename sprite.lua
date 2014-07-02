class = require '30log'
Sprite = class ()
Sprite.__name = 'Sprite'
Sprite.x, Sprite.y = 0, 0
Sprite.drawables = {}

function Sprite:__init()
  self.drawables = {}
end

function Sprite:draw(dt)
  for k,v in ipairs(self.drawables) do
    if v ~= nil then
      v:draw(dt)
    end
  end
end

function Sprite:update(dt)
  for k,v in ipairs(self.drawables) do
    if v ~= nil then
      v:update(dt)
    end
  end
end

function Sprite:add(drawable)
  table.insert(self.drawables, drawable)
end

return Sprite
