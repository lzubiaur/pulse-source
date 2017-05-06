-- dust.lua

local Entity = require 'entities.entity'
local Ground = require 'entities.ground'

local Dust = Class('Dust', Entity)

local random = love.math.random

local maxWidth = 10
local maxHeight = 10
local maxvx = 100
local maxvy = 500
local count = 0

function Dust:initialize(world,x,y)
  Lume.extend(self,{
    dead = false,
    lived = 0, lifetime =1,
  })
  -- self.dx, self.dy = -1,1
  Entity.initialize(self,
    world, x,y,
    love.math.random() * maxWidth,
    love.math.random() * maxHeight,
    { mass = 5, vx = -love.math.random() * maxvx, vy = -love.math.random() * maxvy})
  count = count + 1
end

function Dust:filter(other)
  if other:isInstanceOf(Ground) then
    return 'bounce'
  end
  return nil
end

function Dust:getCount()
  return count
end

function Dust:update(dt)
  if self.dead then return end

  self.lived = self.lived + dt
  if self.lived >= self.lifetime then
    self.dead = true
    self:destroy()
    count = count -1
    return
  end

  self:applyGravity(dt)
  self:applyVelocity(dt)
  self:clampVelocity()

  local x,y,cols,len = self.world:move(self, self.x,self.y, Dust.filter)
  for i=1,len do
    local col = cols[i]
    -- TODO doesnt work if bounciness is smaller than 1
    self:applyCollisionNormal(col.normal.x,col.normal.y,0.9)
  end
end

function Dust:draw()
  local w = love.graphics.getLineWidth()
  love.graphics.setLineWidth(4)
  Entity.draw(self)
  love.graphics.setLineWidth(w)
end

return Dust
