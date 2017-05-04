-- player.lua

local Entity = require 'entities.entity'

local Player = Class('Player', Entity)

function Player:initialize(world, x,y)
  self.vx,self.vy = 200,200
  self.world = world
  self.x,self.y, self.w, self.h = x,y, conf.cellSize, conf.cellSize
  world:add(self, x,y ,self.w, self.h)
end

function Player:draw()
  local r,g,b,a = love.graphics.getColor()
  love.graphics.setColor(0, 255, 0, 255)
  love.graphics.rectangle('line', self.x,self.y, self.w,self.h)
  love.graphics.setColor(r,g,b,a)
end

function Player:update(dt)
  if love.keyboard.isDown('space') then
    self.vy = - self.vy
  end
  self.y = self.y + dt * self.vy
  self.x = self.x + dt * self.vx
  self.x, self.y, cols, len = self.world:move(self, self.x,self.y)
end

return Player
