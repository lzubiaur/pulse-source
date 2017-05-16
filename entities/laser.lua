-- laser.lua

local Enemy = require 'entities.enemy'

local Laser = Class('Laser',Enemy)

-- private
local c = nil
local effect = {
  lightness = 0,
  dir = 1,
}
local color = HUE.new("#00ffff")
local _r,_g,_b = to_rgb(color)
local tween = nil

-- Static update
function Laser.updateEffect(dt)
  if tween:update(effect.dir * dt) then
    effect.dir = - effect.dir
  end
  _r,_g,_b = to_rgb(color:desaturate_to(effect.lightness))
end

function Laser:initialize(world,x,y,w,h)
  Enemy.initialize(self,world,x,y,w,h)
  if not tween then
    tween = Tween.new(0.3,effect,{ lightness = 1 },'inOutQuad')
  end
end

function Laser:draw()
  c = { g.getColor() }

  g.setColor(_r,_g,_b,128)
  g.rectangle('fill',self.x,self.y,self.w,self.h)
  g.setColor(_r,_g,_b,255)
  g.rectangle('line',self.x,self.y,self.w,self.h)

  -- Pop graphics parameters
  g.setColor(unpack(c))
  g.setLineWidth(conf.lineWidth)
end

return Laser
