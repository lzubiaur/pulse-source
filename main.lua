-- main.lua

local platform = love.system.getOS()

-- Global game configuration
conf = {
  build = 'debug',
  -- The game window fixed resolution. Use a 16:9 aspect ratio
  width = 640, height = 360,
  -- Bump world cell size. Should be a multiple of the map's tile size.
  cellSize = 64,
  -- Run on a mobile platform?
  mobileBuild = platform == 'Android' or platform == 'iOS',
}

-- Load 3rd party libraries/modules globally.
-- All modules should start with capital letter.
Class     = require 'modules.middleclass'
Stateful  = require 'modules.stateful'
Inspect   = require 'modules.inspect'
Push      = require 'modules.push'
Loader    = require 'modules.love-loader'
Log       = require 'modules.log'
Bump      = require 'modules.bump'
STI       = require 'modules.sti'
Tween     = require 'modules.tween'
Lume      = require 'modules.lume'
Gamera    = require 'modules.gamera'


-- Load LoveDebug module
-- if conf.build == 'debug' then
--   LoveDebug = require 'modules.lovedebug'
-- end

-- Log level
Log.level = conf.build == 'debug' and 'debug' or 'warn'
Log.usecolor = false

-- Note on loading package:
-- On some platforms like mac osx, the file system is by default not case sensitive
-- which means require is not case sensitive too and might cause some side effect.
-- For instance if we create the file mypackage.lua then require 'myapackage' or require 'MyPackage' or require 'MYPACKAGE' will be able to load
-- "mypackage.lua". But because it's loaded with different names (mypackage, MyPackage or MYPACKAGE) it will be loaded
-- several times and different instance of the package will be kept in the table package.loaded.
-- This can have side effect if we want to use the same package instance but loaded it with a different name.

local Game = require 'game'
-- Load game states after Game
require 'gamestates.loading'
require 'gamestates.play'
require 'gamestates.start'

local game = nil

function love.load()
  -- Avoid anti-alising/blur when scaling. Useful for pixel art.
  -- love.graphics.setDefaultFilter('nearest', 'nearest', 0)

  love.graphics.setBackgroundColor(0,0,0)

  -- Gets the width and height of the window
  local w,h = love.graphics.getDimensions()

  Push:setupScreen(conf.width, conf.height, w,h, {
    fullscreen = conf.mobileBuild,
    resizable = not conf.mobileBuild,
    highdpi = true,
    canvas = true,
    stretched = true, -- Keep aspect ratio or strech to borders
    pixelperfect = false,
  })

  game = Game:new()
end

function love.draw()
  game:draw()
end

function love.update(dt)
  game:update(dt)
end

-- Must call puse:resize when window resizes.
-- Also call on mobile at app launch because fullscreen is enable.
function love.resize(w, h)
  Push:resize(w, h)
end

function love.touchpressed(id, x, y, dx, dy, pressure)
  game:touchpressed(id, x, y, dx, dy, pressure)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
  game:touchmoved(id, x, y, dx, dy, pressure)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
  game:touchreleased(id, x, y, dx, dy, pressure)
end

function love.keypressed(key, isRepeat)
  game:keypressed(key, isRepeat)
end
