Sprite = require 'display.Sprite'
Button = Sprite:extends{}
Button.__name = "Button"

local colour = Colour(102,102,102,255)
local overcolour = Colour(42,143,189,255)
local textcolour = Colour(255,255,255,255)

function Button:__init(x,y,w,h,text,cursor,position)
  self.x, self.y, self.w, self.h = x,y,w,h
  self.text = text
  self.cursor, self.position = cursor,position
  self.active = true
end

function Button:draw(dt)
  if (self.cursor.x == self.position.x or self.position.x == -1) and self.cursor.y == self.position.y then
    if self.active == true then
      love.graphics.setColor(overcolour.r, overcolour.g, overcolour.b, overcolour.a)
    else
      love.graphics.setColor(overcolour.r, overcolour.g, overcolour.b, overcolour.a/2.5)
    end
  else
    if self.active == true then
      love.graphics.setColor(colour.r, colour.g, colour.b, colour.a)
    else
      love.graphics.setColor(colour.r, colour.g, colour.b, colour.a/2.5)
    end
  end
  love.graphics.rectangle("fill", self.x, self.y, self.w, self.h )
  if self.active == true then
    love.graphics.setColor(textcolour.r, textcolour.g, textcolour.b, textcolour.a)
  else
    love.graphics.setColor(textcolour.r, textcolour.g, textcolour.b, textcolour.a/2.5)
  end
  love.graphics.print(self.text, self.x + 6, self.y + 3)
end

return Button
