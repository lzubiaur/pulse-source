-- main.lua

local platform = love.system.getOS()

-- Global game configuration
conf = {
  version = require 'version',
  build = require 'build', -- release/debug build
  -- The game fixed resolution. Use a 16:9 aspect ratio
  width = 640, height = 360,
  -- Bump world cell size. Should be a multiple of the map's tile size.
  cellSize = 64,
  -- Run on a mobile platform?
  mobileBuild = platform == 'Android' or platform == 'iOS',
  -- vertical gravity
  gravity = 1000,
  -- camera
  -- TODO add camera parameters (camera borders, smooth/lerp)
  camOffsetX = 150, -- offset from the player
  camMarginX = 150, -- horizontal outer space allowed to the camera to move outside the map/world
  camMarginY = 150, -- veritcal margin must be big enough so the player is still updated when outside the map.
  playerVelocity = 500, -- Player horizontal velocity in pixel/second. Default 500.
  playerImpulse = -1000, -- vertical impulse when jumping
  playerImpulse2 = -1000, -- jump 2 impulse
  playerMaxVelocity = { x=1000,y=1000 },
  -- color
  hueOffset = 72,
  --
  shaderShift = 4,
  -- grafics
  lineWidth = 8,
  pointSize = 5,
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
Beholder  = require 'modules.beholder'
-- Cron      = require 'modules.cron' -- Not used
-- Chain = require 'modules.knife.chain'
i18n      = require 'modules.i18n'
Timer     = require 'modules.hump.timer'
HUE       = require 'modules.colors'
Parallax  = require 'modules.parallax'
Binser    = require "modules.binser"

-- Love2D shortcuts
g = love.graphics

-- Load LoveDebug module
if conf.build == 'debug' then
  Debug = require 'modules.debug-output'
  -- LoveDebug = require 'modules.lovedebug'
end

local c = HUE.new("#72f63f")
-- local c = HUE.new("#e871a3")

function createPalette(c)
  local t1,t2 = c:triadic()
  return {
    bg   = t2,
    base = c,
    main = c:desaturate_by(.7),
    line = c:desaturate_by(.5),
    fill = c:desaturate_by(.2),
  }
end

function offsetHuePalette(o)
  for k,v in pairs(palette) do
    palette[k] = v:hue_offset(o)
  end
end

-- Global
palette = createPalette(c)

function to_rgb(color)
  return Lume.color(color:to_rgb(),256)
end

-- TODO run stress testing on both to_rgb functions
-- function to_rgb(color)
--   local r,g,b = HUE.hsl_to_rgb(color.H,color.S,color.L)
--   return r*256,g*256,b*256
-- end

-- Log level
Log.level = conf.build == 'debug' and 'debug' or 'warn'
Log.usecolor = true

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
require 'gamestates.start'
require 'gamestates.play'
require 'gamestates.paused'
require 'gamestates.transitions'
require 'gamestates.win'
if conf.build == 'debug' then
  require 'gamestates.debug.play_debug'
end

-- The global game instance
game = nil

function testSaveDirectory()
  love.filesystem.setIdentity('pulse')
  Log.debug('App identity',love.filesystem.getIdentity())
  Log.debug('Save directory:',love.filesystem.getSaveDirectory())
  local path = 'myfile.txt'
  Log.debug('Real directory:',love.filesystem.getRealDirectory(path))
  Log.debug('File exists:',love.filesystem.exists(path))
  Log.debug('Write file:',love.filesystem.write(path,'hello'))
  Log.debug('File exists:',love.filesystem.exists(path))
  local data,size = love.filesystem.read(path)
  Log.debug('Read file:',size == string.len('hello'))
end

function love.load()
  -- Avoid anti-alising/blur when scaling. Useful for pixel art.
  -- love.graphics.setDefaultFilter('nearest', 'nearest', 0)

  -- setBackgroundColor doesnt work with push
  -- love.graphics.setBackgroundColor(0,0,0)

  if conf.build == 'debug' then
    Debug.init()
    testSaveDirectory()
  end

  -- Gets the width and height of the window
  local w,h = love.graphics.getDimensions()

  Push:setupScreen(conf.width, conf.height, w,h, {
    fullscreen = conf.mobileBuild,
    resizable = not conf.mobileBuild,
    highdpi = true,
    canvas = true, -- We need canvas for the separate_chroma shader who works only on texture
    stretched = true, -- Keep aspect ratio or strech to borders
    pixelperfect = false,
  })

  game = Game:new()
end

function love.draw()
  game:draw()
end

function love.update(dt)
  --  if dt > .02 then dt = .02 end
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

function love.keypressed(key, scancode, isrepeat)
  game:keypressed(key, scancode, isRepeat)
end

-- TODO save/restore session
-- TODO android app is put on background/foreground
function love.focus()
end

function love.visible(visible)
end

function love.quit()
  game:destroy()
  Log.info('Quit app')
end

function love.lowmemory()
  Log.warn('System is out of memory')
end
