-- game.lua

local Class    = require 'modules.middleclass'
local Stateful = require 'modules.stateful'

local Game     = Class('Game'):include(Stateful)

function Game:initialize()
  self:gotoState('Start')
end

function Game:update(dt)
end

function Game:draw()
end

function Game:keypressed(key, isRepeat)
end

return Game
