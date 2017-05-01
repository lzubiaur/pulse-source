-- start.lua

local Game = require 'game'

local Start = Game:addState('Start')

function Start:draw()
  Push:apply('start')
  Push:setCanvas('shader')
  love.graphics.print('Push key to start',100,100)
  Push:apply('end')
end

function Start:update(dt)
  self:updateShaders(dt)
end

function Start:keypressed(key, isRepeat)
  self:gotoState('Play')
end

return Start
