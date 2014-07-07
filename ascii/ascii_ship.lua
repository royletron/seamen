AsciiSprite = require 'ascii.ascii_sprite'
AsciiShip = AsciiSprite:extends{}

function AsciiShip:getFrame(dt)
  if self.framerate == 0 then return self.frames[self.currentframe] end
  self.counter = self.counter + dt
  if self.counter > (1 / self.framerate) then
    if self.y == 0 then if math.random(1,5) > 2 then self.y = 1 end end
    if self.y == 1 then if math.random(1,5) > 2 then self.y = 0 end end
    self.counter = 0
  end
  return self.frames[self.currentframe]
end

return AsciiShip
