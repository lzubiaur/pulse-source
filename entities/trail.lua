-- trail.lua

local Entity = require 'entities.entity'

local Trail = Class('Trail',Entity)

function Trail:initialize(world,x,y,w,h,a)
  Entity.initialize(self,world,x,y,w,h)
  self.scale,self.alpha,self.angle = 1,100,a
  local tween = Timer.tween(0.5,self,{scale=0.05,alpha=5})
  Timer.after(0.5,function()
    Timer.cancel(tween)
    self:destroy()
  end)
end

function Trail:update(dt)
end

function Trail:draw()
  g.setColor(0,255,0,self.alpha)
  g.push()
    local ox,oy = self:getCenter()
    g.translate(ox,oy)
    g.scale(self.scale)
    g.rotate(math.rad(self.angle))
    g.rectangle('line', -self.w/2+10,-self.h/2+10,self.w-20,self.h-20)
  g.pop()
end

return Trail
