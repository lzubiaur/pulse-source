-- paused.lua

local Play = require 'gamestates.play'
local Game = require 'game'

local Paused = Game:addState('Paused')

function Paused:enteredState()
  self.music:pause()
end

function Paused:update(dt)
  self:updateShaders(dt, 3, 1)
end

function Paused:keypressed(key, scancode, isrepeat)
  if key == 'p' then
    self.nextStep = false
    self.music:resume()
    -- TODO state name ('Paused') or nil? both work
    self:popState(nil)
  elseif key == 'n' then
    self.nextStep = true
    self:popState(nil)
  end
end

return Paused
