-- game.lua

local Game = Class('Game'):include(Stateful)

local time = 0
local shader1, shader2

function Game:initialize()
  shader1 = love.graphics.newShader("resources/shaders/shader1.fs")
  shader2 = love.graphics.newShader("resources/shaders/shader2.fs")
  Push:setupCanvas({
    -- { name = 'noshader' },
    { name = 'shader1', shader = shader1 },
    -- { name = "shader2", shader = shader2 }
  })
  -- Push:setShader(shader2) --applied to final render

  -- default graphics params
  love.graphics.setLineWidth(8)
  love.graphics.setLineJoin('bevel')
  love.graphics.setPointSize(5)

  self:gotoState('Loading')
end

function Game:updateShaders(dt,shift,alpha)
  time = (time + dt) % 1
  -- TODO shift
  shader1:send('shift', shift + math.cos(time * math.pi * 2) * .5)
  shader1:send('alpha', alpha)
  -- shader2:send("time", love.timer.getTime())
end

function Game:update(dt)
  error('Game:update is not implemented')
end

function Game:draw()
  error('Game:draw is not implemented')
end

function Game:keypressed(key, scancode, isRepeat)
  -- nothing to do
end

function Game:touchpressed(id, x, y, dx, dy, pressure)
end

function Game:touchmoved(id, x, y, dx, dy, pressure)
end

function Game:touchreleased(id, x, y, dx, dy, pressure)
end

return Game
