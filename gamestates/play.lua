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
  self.map = self:loadMap(self.world, 'resources/maps/map02.lua')

  -- Load player position from map
  local x,y = self.map.properties['player.x'] * self.map.tilewidth,
              self.map.properties['player.y'] * self.map.tileheight

  -- Create the player entity
  self.player = Player:new(self.world, x,y)
  -- self.world:update(self.player, x,y)
  Log.debug('Player position:',self.player.x, self.player.y)

  -- Get world map size
  self.worldWidth = self.map.tilewidth * self.map.width
  self.worldHeight = self.map.tileheight * self.map.height
  Log.debug('Map size in px:',self.worldWidth, self.worldHeight)

  -- Create the follow camera. Size of the camera is the size of the map
  self.camera = Gamera.new(0,0, self.worldWidth, self.worldHeight)
  self.camera:setPosition(self.player:getCenter())

  self.camera:setWindow(0,0,conf.width,conf.height)
  Log.debug('camera window',self.camera:getWindow())
end

function Play:exitedState()
  -- TODO
end

function Play:loadMap(world, filename)
  Log.info('Loading map ', filename)

  -- Load a map exported to Lua from Tiled.
  -- STI provides a bump plugin but since we don't use tiles we'll use a
  -- custom loader
  local map = STI(filename)

  for _,o in pairs(map.layers['Ground'].objects) do
    table.insert(self.entities, Ground:new(world,o.x,o.y,o.width,o.height))
  end

  return map
end

function Play:draw()
  local items, len
  Push:start()
  Push:setCanvas('shader')
  self.camera:draw(function(l,t,w,h)
    love.graphics.rectangle('line', 0,0, self.worldWidth,self.worldHeight)
    -- Only draw visible entities
    items,len = self.world:queryRect(l,t,w,h)
    table.sort(items,Entity.sortByZOrder)
    Lume.each(items,'draw')
  end)
  Push:finish()
end

function Play:update(dt)

  self:updateShaders(dt)

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
  self.camera:setPosition(px + 250, Lume.lerp(y,py,0.05))
end

function Play:touchpressed(id, x, y, dx, dy, pressure)
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
