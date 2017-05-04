-- player.lua

local Entity = require 'entities.entity'

local Player = Class('Player', Entity)

function Player:initialize(world, x,y)
  Lume.extend(self, {
      world = world,
      x = x, y = y,
      w = conf.cellSize, h = conf.cellSize,
      vx = 500, vy = 1000, -- gravity
      jumps = 0, -- jump count (max 2)
      force = 0, -- jump force
      released = true, -- touch/key has been released
  })
  world:add(self, x,y ,self.w, self.h)
  -- self.jumpTween = Tween.new(0.5, self, { jumpForce = -800 }, 'inOutSine')
end

function Player:draw()
  local r,g,b,a = love.graphics.getColor()
  love.graphics.setColor(0, 255, 0, 255)
  love.graphics.rectangle('line', self.x,self.y, self.w,self.h)
  love.graphics.setColor(r,g,b,a)
end

function Player:update(dt)
  if self.force < 0 then
    self.force = self.force + 500
    if self.force >= 0 then
      self.force = 0
    end
  end

  if love.keyboard.isDown('space') then
    if self.released and self.jumps < 2 then
      self.force = -4000
      self.jumps = self.jumps + 1
    end
    self.released = false
  else
    self.released = true
  end

  self.y = self.y + dt * (self.vy + self.force)
  self.x = self.x + dt * self.vx

  self.x, self.y, cols, len = self.world:move(self, self.x,self.y)

  if len > 0 and self.jumps > 0 then
    self.jumps = self.jumps - 1
  end
end

return Player
