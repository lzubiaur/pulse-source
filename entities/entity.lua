-- entity.lua

-- Physic world entity
local Entity = Class('Entity')

-- Initialize the entity using a map object
function Entity:initialize(world, o)
  self.x,self.y,self.w,self.h = o.x,o.y,o.width,o.height
  world:add(self, o.x,o.y, o.width,o.height)
end

return Entity
