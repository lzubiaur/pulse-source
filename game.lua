-- game.lua

local Game = Class('Game'):include(Stateful)

local time = 0
local shader1 = nil
-- local shader2 = nil

GameState = {
  path = 'db.data', -- this database filename
  cur = 1, -- current level
  levels = { -- Array with all levels states.
  },
}

function Game:initialize()
  Log.info('Create game instance.')

  -- love.filesystem.remove(GameState.path)
  self:loadGameState()

  shader1 = love.graphics.newShader("resources/shaders/separate_chroma.glsl")
  -- shader2 = love.graphics.newShader("resources/shaders/scanlines.glsl")
  -- Uncomment below to use two post-process effects
  -- Push:setupCanvas({
  --   -- { name = 'noshader' }, -- in case we want a no shader canvas
  --   { name = 'shader1', shader = kaleidoscope },
  -- })
  -- Push:setShader(shader2) --applied to final render

  -- In case we only want one shader
  Push:setShader(shader1)

  -- default graphics params
  love.graphics.setLineWidth(conf.lineWidth)
  love.graphics.setLineJoin('bevel')
  love.graphics.setPointSize(conf.pointSize)

  i18n.loadFile('resources/i18n.lua')

  -- self.nextState = 'Start'
  self:gotoState('Start')
end

function Game:destroy()
  self:saveGameState()
end

function Game:saveGameState()
  local data = Binser.serialize(GameState)
  if not data then
    Log.error('Cannot serialize game state')
    return
  end
  if not love.filesystem.write(GameState.path,data) then
    Log.info('Cannot write to database',path)
  end
end

function Game:loadGameState()
  local fs = love.filesystem
  if fs.exists(GameState.path) then
    local data,len = fs.read(GameState.path)
    data,len = Binser.deserialize(data)
    GameState = data[1]
    Log.debug('Game state = ',Inspect(GameState))
  end
end

function Game:updateShaders(dt,shift,alpha)
  time = (time + dt) % 1
  -- TODO shift
  shader1:send('shift', shift + math.cos(time * math.pi * 2) * 1)
  shader1:send('alpha', alpha)

  -- shader2:send('time', love.timer.getTime())
  -- shader2:send('strength', 10)
end

function Game:update(dt)
  error('Game:update() is not implemented')
end

function Game:draw()
  error('Game:draw() is not implemented')
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
