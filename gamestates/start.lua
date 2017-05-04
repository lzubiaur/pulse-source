-- start.lua

local Game = require 'game'

local Start = Game:addState('Start')

function Start:draw()
  Push:apply('start')

  Push:setCanvas('shader')
  love.graphics.rectangle('line',0,0,conf.width,conf.height)
  -- love.graphics.draw(image1, (gameWidth-image1:getWidth())*.5, (gameHeight-image1:getHeight())*.5 - 100) --global shader + canvas shader will be applied
  love.graphics.setLineWidth(8)
  -- love.graphics.setLineStyle('smooth')
  love.graphics.setLineJoin('bevel')
  love.graphics.rectangle('line', 100,100, 40,40)
  love.graphics.print('Push key to start',100,100)

  Push:setCanvas('noshader')
  Push:apply('end')
end

function Start:update(dt)
  self:updateShaders(dt)
end

function Start:keypressed(key, isRepeat)
  self:gotoState('Play')
end

return Start
