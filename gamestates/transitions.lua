-- transitions.lua

local Game = require 'game'

local GameplayIn = Game:addState('GameplayIn')

function GameplayIn:enteredState()
  Log.info 'Enter state GameplayIn'
  -- running backwards
  -- self.progress.tween:set(self.progress.duration)
  self.progress.tween:reset()
end

function GameplayIn:update(dt)
  if self.progress.tween:update(dt) then
    self:popState()
  end
  self:updateShaders(dt, self.progress.shift, self.progress.alpha)
  self.camera:setPosition(self.player.x,self.player.y)
end

return GameplayIn
