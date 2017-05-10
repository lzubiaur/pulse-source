-- dust.lua

local Entity = require 'entities.entity'

local Dust = Class('Dust', Entity)

local random = love.math.random

-- Private variables
local maxWidth = 10
local maxHeight = 10
local maxvx = 100
local maxvy = 500
local elapsed = 0
local emirate = 10 -- emission rate: Amount of particles emitted per second
local lifetime = 0.4
local size = 10 -- max number of active particles
local count = 0 -- current number of particles

-- Static methods
function Dust.updateParticle(dt,world,x,y)
  elapsed = elapsed + dt
  if count < size and elapsed >= 1 / emirate then
    elapsed,count = 0, count + 1
    Dust:new(world,x,y,lifetime)
  end
end

function Dust:initialize(world,x,y,lifetime)
  Entity.initialize(self,
    world, x,y,
    love.math.random() * maxWidth,
    love.math.random() * maxHeight,
    { mass = 5, vx = -love.math.random() * maxvx, vy = -love.math.random() * maxvy})

  Timer.after(lifetime,function()
    count = count - 1
    self:destroy()
  end)

end

function Dust:filter(other)
  return other.class.name == 'Ground' and 'bounce' or nil
end

function Dust.getCount()
  return count
end

function Dust:update(dt)
  self:applyGravity(dt)
  self:clampVelocity()
  self:applyVelocity(dt)

  self.x,self.y,cols,len = self.world:move(self, self.x,self.y, Dust.filter)
  for i=1,len do
    local col = cols[i]
    self:applyCollisionNormal(col.normal.x,col.normal.y,2)
  end
end

function Dust:draw()
  local w = love.graphics.getLineWidth()
  love.graphics.setLineWidth(4)
  Entity.draw(self)
  love.graphics.setLineWidth(w)
end

return Dust
