-- start.lua

local Game = require 'game'

local Start = Game:addState('Start')

function Start:enteredState()
  Log.info('Entered the state "Start"')

  self.progress = {
    alpha = 0,
    shift = 50,
    dir = 1, -- tween directions (1: forewards, 2:backwards)
    duration = 1,
  }

  self.progress.tween = Tween.new(
    self.progress.duration,
    self.progress,
    { alpha = 1, shift = 3 },
    'inOutCubic')

  Timer.after(0.5,function() self.touchEnabled = true end)

end

function Start:draw()
  Push:start()
    love.graphics.rectangle('line',0,0,conf.width,conf.height)
    love.graphics.line(0,180,640,180)
    love.graphics.print('Push key to start',100,100)
  Push:finish()
end

function Start:update(dt)
  self.progress.tween:update(self.progress.dir * dt)
  self:updateShaders(dt,self.progress.shift,self.progress.alpha)
  Timer.update(dt)
end

function Start:keypressed(key, scancode, isRepeat)
  if self.touchEnabled and not isRepeat then
    self.touchEnabled = false
    self.progress.dir = -1
    self.timer = Timer.after(self.progress.duration,function()
      self:gotoState('Play')
    end)
  end
end

function Start:touchreleased()
  self.progress.dir = -1
end

return Start
