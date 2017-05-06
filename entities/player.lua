-- player.lua

local Entity = require 'entities.entity'
local Ground = require 'entities.ground'
local Dust   = require 'entities.dust'

local Player = Class('Player', Entity)

local maxDust = 8

function Player:initialize(world, x,y)
  Lume.extend(self, {
      impulse = -1000, -- vertical jump impulse
      jumps = 0, -- jump count (max 2)
      released = true, -- touch/key has been released
      dusts = {}, -- dust particles
  })
  -- TODO set player size from map cell size
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

function Player:addDustParticle()
  local dust = Dust:new(self.world,self.x,self.y)
  table.insert(self.dusts,dust)
end

function Player:createDust(col)
  if self.vx > 0 then
    local dust = Dust:new(self.world,self.x + self.w * love.math.random(),self.y+self.h-10)
    table.insert(self.dusts,dust)
  end
end

function Player:filter(other)
  return other:isInstanceOf(Ground) and 'slide' or nil
end

function Player:update(dt)

  Lume.each(self.dusts,'update',dt)

  self:applyGravity(dt)
  self:applyVelocity(dt)
  self:clampVelocity()

  self.x, self.y, cols, len = self.world:move(self, self.x,self.y, Player.filter)

  if len > 0 then
    for i=1,len do
      local col = cols[i]
      if col.other:isInstanceOf(Ground) then
        self:createDust(col)
      end
      -- Decrease jumps count only when player touches ground
      if self.jumps > 0 and col.normal.y < 0 then
        self.jumps = self.jumps - 1
      end
    end
  end
end

return Player
