-- game.lua

local Game = Class('Game'):include(Stateful)

local time = 0
local shader1, shader2

function Game:initialize()
  shader1 = love.graphics.newShader("resources/shaders/shader1.fs")
  shader2 = love.graphics.newShader("resources/shaders/shader2.fs")
  Push:setupCanvas({
    { name = "shader", shader = shader1 }, --applied only to one canvas
    { name = "noshader" }
  })
  Push:setShader(shader2) --applied to final render

  self:gotoState('Loading')
end

function Game:updateShaders(dt)
  time = (time + dt) % 1
  shader1:send("shift", 2 + math.cos( time * math.pi * 2 ) * .5)
  shader2:send("time", love.timer.getTime())
end

function Game:update(dt)
  -- nothing to do
end

function Game:draw()
  -- nothing to do
end

function Game:keypressed(key, scancode, isRepeat)
  -- nothing to do
end

function Game:touchpressed()
  Log.info('Quit game')
  love.event.quit()
end

return Game
