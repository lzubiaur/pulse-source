-- play.lua

local Game   = require 'game'
local Ground = require 'entities.ground'
local Player = require 'entities.player'
local Entity = require 'entities.entity'

local Play = Game:addState('Play')

function Play:enteredState()
  Log.info 'Entered state "Play"'

  self.gameover = false
  self.isReleased = true -- touch flag to check touch is "repeat"
  self.entities = {}

  -- Create the physics world
  self.world = Bump.newWorld(conf.cellSize)

  -- Load the game map
  self.map = self:loadMap(self.world, 'resources/maps/map01.lua')

  -- Load player position from map
  local x,y = self.map.properties['player.x'] * self.map.tilewidth,
              self.map.properties['player.y'] * self.map.tileheight

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

end

function Play:loadMap(world, filename)
  Log.info('Loading map ', filename)

  -- Load a map exported to Lua from Tiled.
  -- STI provides a bump plugin but since we don't use tiles we'll use a
  -- custom loader
  local map = STI('resources/maps/map01.lua')

  for _,o in pairs(map.layers['Ground'].objects) do
    table.insert(self.entities, Ground:new(world,o.x,o.y,o.width,o.height))
  end

  return map
end

function Play:draw()
  local items, len
  self.camera:draw(function(l,t,w,h)
    items,len = self.world:queryRect(l,t,w,h)
    table.sort(items,Entity.sortByZOrder)
    Lume.each(items,'draw')
  end)
end

function Play:update(dt)

  -- TODO gameover
  if self.player.y > self.worldHeight then
    self:gotoState('Start')
  end

  -- Update visible entities
  -- TODO add a radius to update outside the visible windows
  local l,t,h,w = self.camera:getVisible()
  local items,len = self.world:queryRect(l,t,w,h)
  Lume.each(items,'update',dt)

  -- TODO smooth the camera. X doesnt work smoothly
  local x,y = self.camera:getPosition()
  local px, py = self.player:getCenter()
  -- self.camera:setPosition(Lume.lerp(x,self.player.x,0.05),Lume.lerp(y,self.player.y,0.05))
  self.camera:setPosition(px + 250, Lume.lerp(y,py,0.05))
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
