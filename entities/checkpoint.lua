-- checkpoint.lua

local Entity = require 'entities.entity'

local Checkpoint = Class('Checkpoint', Entity)

function Checkpoint:initialize(world,x,y)
  Entity.initialize(self,world,x,y, conf.cellSize, conf.cellSize)
end

function Checkpoint:draw()
  local r,g,b,a = love.graphics.getColor()
  love.graphics.setColor(255,0,0,255)
  Entity.draw(self)
  love.graphics.setColor(r,g,b,a)
end

return Checkpoint
