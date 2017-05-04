-- play.lua

local Game   = require 'game'
local Ground = require 'entities.ground'
local Player = require 'entities.player'

local Play = Game:addState('Play')

function Play:enteredState()
  Log.info 'entered state "Play"'
  self.entities = {}
  self.world = Bump.newWorld(conf.cellSize)
  self.map = self:loadMap(self.world, 'resources/maps/map01.lua')
  self.player = Player:new(self.world, 10, 10)
end

function Play:exitedState()
  Log.info 'exited state "Play"'
end

function Play:loadMap(world, filename)
  Log.info('Load map ', filename)

  -- Load a map exported to Lua from Tiled.
  -- STI provides a bump plugin but since we don't use tiles we'll use a
  -- custom loader
  local map = STI('resources/maps/map01.lua')

  -- print(Inspect(map.layers))
  for _,object in pairs(map.layers['Ground'].objects) do
    table.insert(self.entities, Ground:new(self.world, object))
  end

  for _,entity in ipairs(self.entities) do
    Log.debug(entity.x,entity.y)
  end

  return map
end

function Play:draw()
  for _,entity in ipairs(self.entities) do
    entity:draw()
  end
  self.player:draw()
end

function Play:update(dt)
  self.player:update(dt)
end

return Play
