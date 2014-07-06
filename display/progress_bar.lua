Sprite = require 'display.Sprite'
ProgressBar = Sprite:extends{}
ProgressBar.__name = "ProgressBar"

function ProgressBar:__init(x, y, w, min, max)
  self.x, self.y, self.w = x,y,w
  self.renderer = Renderer(x,y,w,1)
  self.min, self.max = min, max
end

function ProgressBar:setValue(val)
  self.value = val
end

function ProgressBar:update(dt)
  local step = (self.max-self.min)/self.w
  for s=1, self.w, 1 do
    if (step * s) < self.value then
      self.renderer:drawChar(s, 1, Char:new(s, 1, '≋', Colour(255,100,100,255), Colour(50,169,167,255)))
    else
      self.renderer:drawChar(s, 1, Char:new(s, 1, '≋', Colour(255,100,100,0), Colour(50,169,167,0)))
    end
  end
end

function ProgressBar:draw(dt)
  self.renderer:draw(dt)
end

return ProgressBar
