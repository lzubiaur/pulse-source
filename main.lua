-- main.lua

local inspect = require 'modules.inspect'

-- Note on loading package:
-- On some platforms like mac osx, the file system is by default not case sensitive
-- which means require is not case sensitive too and might cause some side effect.
-- For instance if we create the file mypackage.lua then require 'myapackage' or require 'MyPackage' or require 'MYPACKAGE' will be able to load
-- "mypackage.lua". But because it's loaded with different names (mypackage, MyPackage or MYPACKAGE) it will be loaded
-- several times and different instance of the package will be kept in the table package.loaded.
-- This can have side effect if we want to use the same package instance but loaded it with a different name.

local Game = require 'game'
require 'gamestates.play'
require 'gamestates.start'

local game = nil

function love.load()
  game = Game:new()
end

function love.draw()
  game:draw()
end

function love.update(dt)
  game:update(dt)
end

function love.keypressed(key, isRepeat)
  game:keypressed(key, isRepeat)
end
