-- enemy.lua

local Entity = require 'entities.entity'

local Enemy = Class('Enemy', Entity)

function Enemy:initialize(world,x,y)
  Entity.initialize(self,world,x,y, conf.cellSize, conf.cellSize)
end

function Enemy:draw()
  local r,g,b,a = love.graphics.getColor()
  love.graphics.setColor(255,0,0,255)
  Entity.draw(self)
  love.graphics.setColor(r,g,b,a)
end

return Enemy
