-- player.lua

local Entity = require 'entities.entity'
local Ground = require 'entities.ground'
local Dust   = require 'entities.dust'

local Player = Class('Player', Entity)

function Player:initialize(world, x,y)
  Lume.extend(self, {
      impulse = conf.playerImpulse, -- vertical jump impulse
      jumps = 0,                    -- jump count (max 2)
      released = true,              -- touch/key has been released
      cpx = x, cpy = y,             -- last passed checkpoint
      angle = 0,                    -- Current angle in degree
  })
  -- TODO set player size from actual map cell size
  Entity.initialize(self,world,x,y,conf.cellSize,conf.cellSize,{vx = conf.playerVelocity, mass = 5, zOrder = 1})
  self.rotTween = Tween.new(0.3,self,{angle = 90})
  self.longRotTween = Tween.new(0.3,self,{angle = 180})

  Beholder.observe('ResetGame',function() self:onResetGame() end)
end

function Player:onResetGame()
  Log.info('Reset Player')
  self.rotTween:reset()
  self.longRotTween:reset()
  self.jumps,self.angle = 0,0
  self.impulse = conf.playerImpulse
end

function Player:jump()
  if self.jumps < 2 then
    self.vy = self.impulse
    self.jumps = self.jumps + 1
    if self.jumps == 2 then
      self.longRotTween = nil
      self.longRotTween = Tween.new(0.3,self,{angle = 180})
    end
  end
end

function Player:goToCheckPoint()
  self.x, self.y = self.cpx, self.cpy
  self.world:update(self,self.x,self.y)
end

function Player:draw()
  -- print(self:getCenterToScreen()) -- TODO why first x is different?
  g.setColor(to_rgb(palette.main))
  if self.angle == 0 then
    g.rectangle('line', self.x,self.y,self.w,self.h)
    g.rectangle('fill', self.x+10,self.y+10,self.w-20,self.h-20)
  else
    g.push()
      local ox,oy = self:getCenter()
      g.translate(ox,oy)
      g.rotate(math.rad(self.angle))
      g.rectangle('line', -self.w/2,-self.h/2,self.w,self.h)
      g.rectangle('fill', -self.w/2+10,-self.h/2+10,self.w-20,self.h-20)
    g.pop()
  end
end

function Player:filter(other)
  if other:isInstanceOf(Ground) then
    return 'slide'
  elseif other.class.name == 'Checkpoint' then
    return 'cross'
  elseif other.class.name == 'Laser' then
    return 'cross'
  end
  return nil
end

function Player:rotate(dt)
  if self.jumps == 1 then
    self.rotTween:update(dt)
  elseif self.jumps == 2 then
    self.longRotTween:update(dt)
  end
end

function Player:update(dt)
  -- TODO Fix maximum jump height?
  self:applyGravity(dt)
  self:applyVelocity(dt)
  self:clampVelocity()
  self:rotate(dt)

  self.x, self.y, cols, len = self.world:move(self, self.x,self.y, Player.filter)
  self:checkCollisions(dt, len, cols)
  Debug.update('vy',self.vy)
end

function Player:checkCollisions(dt,len, cols)
  if len < 1 then return end

  for i=1,len do
    local col = cols[i]
    if col.other:isInstanceOf(Ground) then
      -- TODO create dust only when touching the ground and is moving
      Dust.updateParticle(dt,self.world,self.x + self.w * love.math.random(), self.y + self.h - 10)
      -- Decrease jumps count only when player touches ground
      if self.jumps > 0 and col.normal.y < 0 then
        self.rotTween:reset()
        self.longRotTween:reset()
        self.angle = 0
        self.jumps = self.jumps - 1
      end
    elseif col.other.class.name == 'Checkpoint' then
      self.cpx,self.cpy = col.other.x, col.other.y
    elseif col.other.class.name == 'Laser' then
      Beholder.trigger('Gameover')
    end
  end
end

return Player
