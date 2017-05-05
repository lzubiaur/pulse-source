-- player.lua

local Entity = require 'entities.entity'

local Player = Class('Player', Entity)

function Player:initialize(world, x,y)
  Lume.extend(self, {
      world = world,
      x = x, y = y, -- position
      -- TODO set player size from map cell size
      w = conf.cellSize, h = conf.cellSize, -- size
      vx = 800, vy = 0, -- current velocity
      mx = 800, my = 800, -- max velocity
      gy = 4000, -- vertical gravity
      impulse = -1000, -- vertical jump impulse
      jumps = 0, -- jump count (max 2)
      released = true, -- touch/key has been released
  })
  world:add(self, x,y ,self.w, self.h)
  -- self.jumpTween = Tween.new(0.5, self, { jumpForce = -800 }, 'inOutSine')
end

function Player:jump()
  if self.jumps < 2 then
    self.vy = self.impulse
    self.jumps = self.jumps + 1
  end
end

function Player:draw()
  local r,g,b,a = love.graphics.getColor()
  love.graphics.setColor(0, 255, 0, 255)
  love.graphics.rectangle('line', self.x,self.y, self.w,self.h)
  love.graphics.setColor(r,g,b,a)
end

function Player:update(dt)
  -- Apply vertical gravity
  self.vy = self.vy + dt * self.gy

  -- clamp velocity
  self.vx = Lume.sign(self.vx) * Lume.clamp(math.abs(self.vx), 0, self.mx)
  self.vy = Lume.sign(self.vy) * Lume.clamp(math.abs(self.vy), 0, self.my)

  -- Apply velocity
  self.x = self.x + dt * self.vx
  self.y = self.y + dt * self.vy

  self.x, self.y, cols, len = self.world:move(self, self.x,self.y)

  -- Decrease jumps count if player touches ground but not walls and roof
  if len > 0 and self.jumps > 0 then
    for i=1,len do
      if cols[i].normal.y < 0 then
        self.jumps = self.jumps - 1
      end
    end
  end
end

return Player
