-- ground.lua

local Entity = require 'entities.entity'

local Ground = Class('Ground', Entity)

function Ground:initialize(world, object)
  Entity.initialize(self, world, object)
end

function Ground:draw()
  love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
end

function Ground:update(dt)
end

return Ground
