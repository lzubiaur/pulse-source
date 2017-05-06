-- entity.lua

-- Physic world entity
local Entity = Class('Entity')

function Entity:initialize(world, x,y, w,h, opt)
  opt = opt or {}
  Lume.extend(self,{
    world = world,
    x = x, y = y, -- position
    w = w, h = h, -- size
    -- Options
    zOrder = opt.zOrder or 0, -- draw z order
    mx = opt.mx or 800, my = opt.my or 800, -- maximum velocity
    vx = opt.vx or 0, vy = opt.vy or 0, -- current velocity
    mass = opt.mass or 1,
  })
  -- Log.debug('create entity ',self,x,y,self.mx,self.my,self.zOrder)
  -- add this instance to the physics world
  world:add(self, x,y, w,h)
end

function Entity:getCenter()
  return self.x + self.w / 2, self.y + self.h / 2
end

function Entity:applyGravity(dt)
  self.vy = self.vy + self.mass * conf.gravity * dt
  return self.vy
end

function Entity:applyVelocity(dt)
  self.x = self.x + self.vx * dt
  self.y = self.y + self.vy * dt
end

function Entity:clampVelocity()
  self.vx = Lume.sign(self.vx) * Lume.clamp(math.abs(self.vx), 0, self.mx)
  self.vy = Lume.sign(self.vy) * Lume.clamp(math.abs(self.vy), 0, self.my)
end

function Entity:destroy()
  self.world:remove(self)
end

-- code from bump.lua demo
function Entity:applyCollisionNormal(nx, ny, bounciness)
  bounciness = bounciness or 0
  local vx, vy = self.vx, self.vy

  if (nx < 0 and vx > 0) or (nx > 0 and vx < 0) then
    vx = -vx * bounciness
  end

  if (ny < 0 and vy > 0) or (ny > 0 and vy < 0) then
    vy = -vy * bounciness
  end

  self.vx, self.vy = vx, vy
end

function Entity:sortByZOrder(other)
  return self.zOrder < other.zOrder
end

function Entity:update(dt)
  -- nothing
end

function Entity:draw()
  love.graphics.rectangle('line',self.x,self.y,self.w,self.h)
end

return Entity
