-- play.lua

local Game   = require 'game'
local Ground = require 'entities.ground'
local Player = require 'entities.player'

local Play = Game:addState('Play')

function Play:enteredState()
  Log.info 'entered state "Play"'
  self.entities = {}
  -- Create the physics world
  self.world = Bump.newWorld(conf.cellSize)
  -- Load the game map
  self.map = self:loadMap(self.world, 'resources/maps/map01.lua')
  -- TODO load player position from map
  local ox,oy = 10,10
  -- Create the player entity
  self.player = Player:new(self.world, ox,oy)
  -- Change the world position to the player's position
  self.world:update(self.player, ox,oy)
  -- Get world map size
  self.worldWidth = self.map.tilewidth * self.map.width
  self.worldHeight = self.map.tileheight * self.map.height
  -- Create the follow camera
  self.camera = Gamera.new(0,0, self.worldWidth, self.worldHeight)
  self.camera:setPosition(ox,oy)
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

  for _,object in pairs(map.layers['Ground'].objects) do
    table.insert(self.entities, Ground:new(self.world, object))
  end

  return map
end

function Play:draw()
  self.camera:draw(function(l,t,w,h)
    for _,entity in ipairs(self.entities) do
      entity:draw()
    end
    self.player:draw()
  end)
end

function Play:update(dt)
  self.player:update(dt)
  -- TODO why lerp?
  -- local x,y = self.camera:getPosition()
  -- self.camera:setPosition(Lume.lerp(x,self.player.x,0.5),Lume.lerp(y,self.player.y,0.5))
  self.camera:setPosition(self.player.x, self.player.y)
end

return Play
