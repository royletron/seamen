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
  local step = (max-min)/w
  for s=1, w, 1 do
    if (step * s) < self.value then
      
    end
  end
end

function ProgressBar:draw(dt)
  self.renderer:draw(dt)
end

return ProgressBar
