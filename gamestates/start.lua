-- start.lua

local Game = require 'game'

local Start = Game:addState('Start')

function Start:enteredState()
  Log.info('Entered the state "Start"')

  self.font = g.newFont('resources/fonts/pzim3x5.fnt','resources/fonts/pzim3x5.png')
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
  local text = i18n(conf.mobileBuild and 'start_mobile' or 'start_desktop')
  local h = self.font:getHeight()

  Push:start()
    g.clear(to_rgb(palette.bg))
    g.setColor(to_rgb(palette.base))
    g.rectangle('line',0,0,conf.width,conf.height)
    g.printf(text,0,conf.height/2-h/2,conf.width,'center')
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
    -- self.nextState = 'Play'
    self:gotoState('Play')
  end)
end

function Start:keypressed(key, scancode, isRepeat)
  if not self.touchEnabled and isRepeat then return end
  if key == 'space' then
    self.touchEnabled = false
    self:fadeout()
  -- On Android the back button is mapped to the 'escape' key
  elseif key == 'escape' then
    love.event.push('quit')
  end
end

function Start:touchreleased()
  self:fadeout()
end

return Start
