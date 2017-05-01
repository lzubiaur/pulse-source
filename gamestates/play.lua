-- play.lua

local Game =  require 'game'

local Play = Game:addState('Play')

function Play:enteredState()
  print 'enter state'
end

function Play:exitedState()
  print 'exited state'
end

function Play:draw()
  love.graphics.print('...',10,10)
end

function Play:update(dt)
end

return Play
