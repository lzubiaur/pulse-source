-- enemy.lua

local Entity = require 'entities.entity'

local Enemy = Class('Enemy', Entity)

function Enemy:initialize(world,x,y,w,h)
  w = w or conf.cellSize
  h = h or conf.cellSize
  Entity.initialize(self,world,x,y,w,h,{ zOrder = -1 })
end

function Enemy:draw()
  local r,g,b,a = love.graphics.getColor()
  love.graphics.setColor(255,0,0,255)
  Entity.draw(self)
  love.graphics.setColor(r,g,b,a)
end

return Enemy
