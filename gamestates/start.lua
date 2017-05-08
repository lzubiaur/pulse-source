-- start.lua

local Game = require 'game'

local Start = Game:addState('Start')

function Start:draw()
  Push:start()
    love.graphics.rectangle('line',0,0,conf.width,conf.height)
    love.graphics.print('Push key to start',100,100)
  Push:finish()
end

function Start:update(dt)
  self:updateShaders(dt,3)
end

function Start:keypressed(key, isRepeat)
  self:gotoState('Play')
end

function Start:touchreleased()
  self:gotoState('Play')
end

return Start
