-- player.lua

local Entity = require 'entities.entity'
local Ground = require 'entities.ground'
local Dust   = require 'entities.dust'

local Player = Class('Player', Entity)

local maxDust = 8

function Player:initialize(world, x,y)
  print(x,y)
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

function Player:draw()
  local r,g,b,a = love.graphics.getColor()
  love.graphics.setColor(0, 255, 0, 255)
  love.graphics.rectangle('line', self.x,self.y, self.w,self.h)
  love.graphics.setColor(r,g,b,a)
  love.graphics.points(self:getCenter())
end

-- TODO limit the dust particle number
function Player:addDustParticle(col)
  if self.vx > 0 then
    -- TODO dust position
    Dust:new(self.world,self.x+self.w * love.math.random(),self.y+self.h-10)
  end
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
  self:checkCollisions(len, cols)
end

function Player:checkCollisions(len, cols)
  if len < 1 then return end

  for i=1,len do
    local col = cols[i]
    if col.other:isInstanceOf(Ground) then
      self:addDustParticle()
      -- Decrease jumps count only when player touches ground
      if self.jumps > 0 and col.normal.y < 0 then
        self.jumps = self.jumps - 1
      end
    elseif col.other.class.name == 'Checkpoint' then
      print('checkpoint',col.other.x,col.other.y)
      self.cpx,self.cpy = col.other.x, col.other.y
    end
  end
end

return Player
