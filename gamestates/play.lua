-- play.lua

local Game   = require 'game'
local Ground = require 'entities.ground'
local Player = require 'entities.player'

local Play = Game:addState('Play')

function Play:enteredState()
  Log.info 'Entered state "Play"'
  self.isReleased = true -- touch flag to check touch is "repeat"
  self.entities = {}
  -- Create the physics world
  self.world = Bump.newWorld(conf.cellSize)
  -- Load the game map
  self.map = self:loadMap(self.world, 'resources/maps/map01.lua')
  -- Load player position from map
  local x,y = self.map.properties['player.x'] * self.map.tilewidth,
              self.map.properties['player.y'] * self.map.tileheight
  Log.debug('Player position',x,y)
  -- Create the player entity
  self.player = Player:new(self.world, x,y)
  -- Change the world position to the player's position
  self.world:update(self.player, x,y)
  -- Get world map size
  self.worldWidth = self.map.tilewidth * self.map.width
  self.worldHeight = self.map.tileheight * self.map.height
  -- Create the follow camera. Size of the camera is the size of the map
  self.camera = Gamera.new(0,0, self.worldWidth, self.worldHeight)
  self.camera:setPosition(x,y)
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
  -- self.camera:setPosition(self.player.x + conf.width * 0.5, self.player.y)

  -- TODO smooth the camera
  local x,y = self.camera:getPosition()
  self.camera:setPosition(Lume.lerp(x,self.player.x,0.05),Lume.lerp(y,self.player.y,0.05))
end

function Play:touchpressed(id, x, y, dx, dy, pressure)
  Log.debug('touch pressed')
  if self.isReleased then
    self.player:jump()
  end
  self.isReleased = false
end

function Play:touchmoved(id, x, y, dx, dy, pressure)
end

function Play:touchreleased(id, x, y, dx, dy, pressure)
  self.isReleased = true
end

function Play:keypressed(key, scancode, isrepeat)
  if key == 'space' and not isrepeat then
    self.player:jump()
  end
end

return Play
