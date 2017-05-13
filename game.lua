-- game.lua

local Game = Class('Game'):include(Stateful)

local time = 0
local kaleidoscope, scanlines

function Game:initialize()
  kaleidoscope = love.graphics.newShader("resources/shaders/kaleidoscope.glsl")
  scanlines = love.graphics.newShader("resources/shaders/scanlines.glsl")
  Push:setupCanvas({
    -- { name = 'noshader' },
    { name = 'kaleidoscope', shader = kaleidoscope },
    -- { name = "shader2", shader = shader2 }
  })
  Push:setShader(scanlines) --applied to final render

  -- default graphics params
  love.graphics.setLineWidth(8)
  love.graphics.setLineJoin('bevel')
  love.graphics.setPointSize(5)

  i18n.loadFile('resources/i18n.lua')

  self:gotoState('Loading')
end

function Game:updateShaders(dt,shift,alpha)
  time = (time + dt) % 1
  -- TODO shift
  kaleidoscope:send('shift', shift + math.cos(time * math.pi * 2) * .5)
  kaleidoscope:send('alpha', alpha)

  scanlines:send('time', love.timer.getTime())
  scanlines:send('strength', 10)
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
