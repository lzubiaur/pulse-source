-- loading.lua

local Game = require 'game'

local Loading = Game:addState('Loading')

function Loading:enteredState()
  self.font = love.graphics.newFont('resources/fonts/pzim3x5.fnt','resources/fonts/pzim3x5.png')
  love.graphics.setFont(self.font)
end

function Loading:draw()
  love.graphics.print('Loading...', 300,300)
end

function Loading:update(dt)
  self:gotoState('Start')
end

return Loading
