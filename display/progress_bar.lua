Sprite = require 'display.Sprite'
ProgressBar = Sprite:extends{}
ProgressBar.__name = "ProgressBar"

function ProgressBar:__init(x, y, w, min, max)
  self.x, self.y, self.w = x,y,w
  self.renderer = Renderer(x,y,w,1)
  self.min, self.max = min, max
  self.value = 0
end

function ProgressBar:setValue(val)
  if val > self.max then
    self.value = self.max
  else
    if val < self.min then
      self.value = self.min
    else
      self.value = val
    end
  end
end

function ProgressBar:update(dt)
  local step = (self.max-self.min)/self.w
  for s=1, self.w, 1 do
    if (step * s) <= self.value then
      self.renderer:drawChar(s, 1, Char:new(s, 1, '∷', Colour(134,177,183,255), Colour(192,237,252,255)))
    else
      self.renderer:drawChar(s, 1, Char:new(s, 1, '-', Colour(255,255,255,255), Colour(117,154,159,255)))
    end
  end
end

function ProgressBar:draw(dt)
  self.renderer:draw(dt)
end

return ProgressBar
