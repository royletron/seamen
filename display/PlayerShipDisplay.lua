require('ascii.ships')
require('ascii.hud')
require('ascii.landlubber')

local AsciiSprite = require('ascii.ascii_sprite')
local AsciiRenderer = require('ascii.ascii_renderer')
local AsciiShip = require('ascii.ascii_ship')
local Renderer = require('display.renderer')
local Baddie = require('entities.baddie')
local Sprite = require 'display.Sprite'

PlayerShipDisplay = Sprite:extends{}
PlayerShipDisplay.__name = "PlayerShipDisplay"

local ship_renderer

function PlayerShipDisplay:__init(x, y)
  ship_renderer = Renderer(x, y, 27, 21, label_font, char_font)
  self.x, self.y, self.width, self.height = ship_renderer.x, ship_renderer.y, ship_renderer.width, ship_renderer.height

  local ship = AsciiRenderer()
  ship:add(AsciiSprite(SHIP_BG))
  local water_bg = AsciiSprite(WATER_ANIMATION, Colour(96,120,144,255))
  water_bg.framerate = 20
  water_bg.y = 10
  ship:add(water_bg)
  ship:add(AsciiShip(SHIP_FRIGGATTE))
  ship:add(AsciiSprite(WATER_ANIMATION))
  ship_renderer:setAscii(ship)
end

function PlayerShipDisplay:update(dt)
  ship_renderer:update(dt)
end

function PlayerShipDisplay:draw(dt)
  ship_renderer:draw(dt)
end

return PlayerShipDisplay
