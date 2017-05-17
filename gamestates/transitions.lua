-- transitions.lua

local Game = require 'game'

-- GameplayIn

local GameplayIn = Game:addState('GameplayIn')

function GameplayIn:enteredState()
  Log.info 'Enter state GameplayIn'
  self.progress.tween:reset()

  local position = self.player.x/conf.playerVelocity
  Log.info('Seek music to position ', position)
  self.music:seek(position, 'seconds')
  self.music:setVolume(0)
  love.audio.play(self.music)
end

function GameplayIn:exitedState()
  Log.info 'Exited state GameplayIn'
end

function GameplayIn:update(dt)
  if self.progress.tween:update(dt) then
    self:popState()
  end
  self.music:setPitch(self.progress.pitch)
  self.music:setVolume(self.progress.volume)
  self:updateShaders(dt, self.progress.shift, self.progress.alpha)
  local x,y = self.camera:getPosition()
  local px, py = self.player:getCenter()
  self.camera:setPosition(px + conf.camOffsetX, Lume.lerp(y,py,0.05))
end

function GameplayIn:keypressed(key, scancode, isRepeat)
  -- disable touche
end

-- GameplayOut

local GameplayOut = Game:addState('GameplayOut')

function GameplayOut:enteredState()
  Log.info 'Enter state GameplayOut'
  -- running backwards
  self.progress.tween:set(self.progress.duration)
end

function GameplayOut:exitedState()
  Log.info 'Exited state GameplayOut'
end

function GameplayOut:update(dt)
  if self.progress.tween:update(-dt) then
    self:popState()
    Beholder.trigger('ResetGame')
  end
  self.music:setPitch(self.progress.pitch)
  self.music:setVolume(self.progress.volume)
  self:updateShaders(dt, self.progress.shift, self.progress.alpha)
end

function GameplayOut:onGameOver()
  Log.info('Received gameover. Ignored.')
end

function GameplayOut:keypressed(key, scancode, isRepeat)
  -- disable touches
end
