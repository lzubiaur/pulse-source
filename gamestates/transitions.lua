-- transitions.lua

local Game = require 'game'

local GameplayIn = Game:addState('GameplayIn')

function GameplayIn:enteredState()
  Log.info 'Enter state GameplayIn'
  self.time = 0
end

function GameplayIn:update(dt)
  self.time = self.time + dt
  if self.time >= 0.5 then self:popState() end
  self:updateShaders(dt, 10 - self.time)
  self.camera:setPosition(self.player.x,self.player.y)
  print 'udpate'
end

return GameplayIn
