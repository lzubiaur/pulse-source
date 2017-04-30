-- main.lua

local Game = require "game"

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
