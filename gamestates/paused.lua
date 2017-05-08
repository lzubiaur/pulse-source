-- paused.lua

local Play = require 'gamestates.play'
local Game = require 'game'

-- local Paused = Class('Paused', Play)
local Paused = Game:addState('Paused')

function Paused:update(dt)
end

function Paused:keypressed(key, scancode, isrepeat)
  if key == 'p' then
    self:popState('Paused')
  end
end

return Paused
