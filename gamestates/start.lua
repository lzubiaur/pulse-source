-- start.lua

local Game = require 'game'

local Start = Game:addState('Start')

function Start:enteredState()
  Log.info('Entered the state "Start"')

  g.setFont(self.font)

  self.progress = {
    alpha = 0,
    shift = 80,
    pitch = 0.1, -- music pitch
    volume = 0,
    dir = 1, -- tween directions (1: forewards, 2:backwards)
    duration = 1,
  }

  self.progress.tween = Tween.new(
    self.progress.duration,
    self.progress,
    { alpha = 1, shift = conf.shaderShift, pitch = 1, volume = 1 },
    'inOutCubic')

  Timer.after(0.5,function() self.touchEnabled = true end)

end

function Start:draw()
  Push:start()
    g.clear(to_rgb(palette.bg))
    g.setColor(to_rgb(palette.base))
    g.rectangle('line',0,0,conf.width,conf.height)
    g.line(0,180,640,180)
    g.print(i18n(conf.mobileBuild and 'start_mobile' or 'start_desktop'),100,100)
  Push:finish()
end

function Start:update(dt)

  self.progress.tween:update(self.progress.dir * dt)
  self:updateShaders(dt,self.progress.shift,self.progress.alpha)
  Timer.update(dt)
end

function Start:fadeout()
  self.progress.dir = -1
  self.timer = Timer.after(self.progress.duration,function()
    self.nextState = 'Play'
    self:gotoState('Loading')
  end)
end

function Start:keypressed(key, scancode, isRepeat)
  if self.touchEnabled and not isRepeat then
    if key == 'space' then
      self.touchEnabled = false
      self:fadeout()
    elseif key == 'c' then
      offsetHuePalette(conf.hueOffset)
    end
  end
end

function Start:touchreleased()
  self:fadeout()
end

return Start
