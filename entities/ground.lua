-- ground.lua

local Entity = require 'entities.entity'

local Ground = Class('Ground', Entity)

function Ground:initialize(world,x,y,w,h)
  Entity.initialize(self, world,x,y,w,h)
end

function Ground:draw()
  g.setColor(to_rgb(palette.fill))
  g.rectangle('fill',self.x,self.y,self.w,self.h)
  g.setColor(to_rgb(palette.line))
  g.rectangle('line',self.x,self.y,self.w,self.h)
end

return Ground
