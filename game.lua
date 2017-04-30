-- game.lua

local Class    = require 'modules.middleclass'
local Stateful = require 'modules.stateful'

local Start    = require 'gamestates.start'
local Play     = require 'gamestates.play'

local Game     = Class('Game'):include(Stateful)

Game:addState('Start', Start)
Game:addState('Play', Play)

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
