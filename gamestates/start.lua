-- start.lua

local Start = {}

function Start:draw()
  love.graphics.print('Push key to start',100,100)
end

function Start:update(dt)
end

function Start:keypressed(key, isRepeat)
  self:gotoState('Play')
end

return Start
