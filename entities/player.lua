-- player.lua

local Entity = require 'entities.entity'
local Ground = require 'entities.ground'
local Dust   = require 'entities.dust'

local Player = Class('Player', Entity)

function Player:initialize(world, x,y)
  Lume.extend(self, {
      impulse = -1000,      -- vertical jump impulse
      jumps = 0,            -- jump count (max 2)
      released = true,      -- touch/key has been released
      cpx = x, cpy = y,     -- last passed checkpoint
  })
  -- TODO set player size from actual map cell size
  Entity.initialize(self,world,x,y,conf.cellSize,conf.cellSize,{vx = 500, mass = 5, zOrder = 1})
end

function Player:jump()
  if self.jumps < 2 then
    self.vy = self.impulse
    self.jumps = self.jumps + 1
  end
end

function Player:setPositionToCheckPoint()
  self.x, self.y = self.cpx, self.cpy
  self.world:update(self,self.x,self.y)
end

function Player:draw()
  local x,y,w,h = self.x,self.y,self.w,self.h
  -- TODO doesn't work
  -- gfx.translate(self:getCenterToScreen())
  -- gfx.rotate(math.rad(45))
  gfx.setColor(255, 255, 0, 255)
  gfx.rectangle('line', x, y, w, h)
end

function Player:filter(other)
  if other:isInstanceOf(Ground) then
    return 'slide'
  elseif other.class.name == 'Checkpoint' then
    return 'cross'
  end
  return nil
end

function Player:update(dt)

  self:applyGravity(dt)
  self:applyVelocity(dt)
  self:clampVelocity()

  self.x, self.y, cols, len = self.world:move(self, self.x,self.y, Player.filter)
  self:checkCollisions(dt, len, cols)
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
        self.jumps = self.jumps - 1
      end
    elseif col.other.class.name == 'Checkpoint' then
      self.cpx,self.cpy = col.other.x, col.other.y
    end
  end
end

return Player
