-- ground.lua

local Entity = require 'entities.entity'

local Ground = Class('Ground', Entity)

function Ground:initialize(world,x,y,w,h)
  Entity.initialize(self, world,x,y,w,h)
end

return Ground
