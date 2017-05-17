-- play.lua

local Game   = require 'game'
local Ground = require 'entities.ground'
local Player = require 'entities.player'
local Entity = require 'entities.entity'
local Checkpoint = require 'entities.checkpoint'
local Laser = require 'entities.laser'

local Play = Game:addState('Play')

function Play:enteredState()
  Log.info 'Entered state "Play"'

  Debug.setEnabled(true)

  -- Must clear the timer on entering the scene or old timer will still running
  Timer.clear()

  self.musicDuration = self.music:getDuration('seconds')

  self.isReleased = true -- touch flag to check touch is "repeat"

  -- Create the physics world
  self.world = Bump.newWorld(conf.cellSize)

  -- Load the game map
  local map = self:loadMap(self.world, 'resources/maps/map01.lua')

  -- Load player position from map
  local x,y = map.properties['player.x'] * map.tilewidth,
              map.properties['player.y'] * map.tileheight

  -- Create the player entity
  self.player = Player:new(self.world, x,y)
  -- self.world:update(self.player, x,y)
  Log.debug('Player position:',self.player.x, self.player.y)

  -- Get world map size
  self.worldWidth = map.tilewidth * map.width
  self.worldHeight = map.tileheight * map.height
  Log.debug('Map size in px:',self.worldWidth, self.worldHeight)

  -- Create the follow camera. Size of the camera is the size of the map
  -- Add an offset to the left to avoid a jump in the camera when starting
  -- if the player is at the very left
  self.camera = Gamera.new(-100,0, self.worldWidth, self.worldHeight)
  -- local x,y = self.player:getCenter()
  -- self.camera:setPosition(x + 250,y)
  -- Camera window must be set to the game resolution and not the
  -- the actual screen resolution
  self.camera:setWindow(0,0,conf.width,conf.height)
  Log.debug('camera window',self.camera:getWindow())

  local px, py = self.player:getCenter()
  self.camera:setPosition(x + conf.camOffsetX, y)

  self.parallax = Parallax(conf.width,conf.height, {offsetX = 0, offsetY = 0})
  self.parallax:addLayer('layer0',1,{relativeScale=0.2})
  self.parallax:addLayer('layer1',1,{relativeScale=0.4})
  self.parallax:addLayer('layer2',1,{relativeScale=0.8})

  self.vertices = {}
  for i=1,3 do
    table.insert(self.vertices,self:generateBackground())
  end

  Beholder.observe('Gameover',function() self:onGameOver() end)
  Beholder.observe('ResetGame',function() self:onResetGame() end)

  self:pushState('GameplayIn')
end

function Play:exitedState()
  Log.info 'Exited state Play'
  -- TODO clean up?
  Timer.clear()
end

function Play:loadMap(world, filename)
  Log.info('Loading map ', filename)

  -- Load a map exported to Lua from Tiled.
  -- STI provides a bump plugin but since we don't use tiles we'll use a
  -- custom loader
  local map = STI(filename)

  for _,o in pairs(map.layers['Ground'].objects) do
    Ground:new(world,o.x,o.y,o.width,o.height)
  end

  for _,o in pairs(map.layers['Checkpoint'].objects) do
    if o.type == 'Checkpoint' then
      Checkpoint:new(world,o.x,o.y)
    elseif o.type == 'Spike' then
      Laser:new(world,o.x,o.y,o.width,o.height)
    else
      Log.warn('Unknow type:',o.type)
    end
  end

  return map
end

-- TODO check layer relative scale
function Play:generateBackground()
  local t,x,y,dx,dy,i = {},0,self.worldHeight-200,1,{0,-1,0,1},1
  local rand = love.math.random
  while true do
    x = x + dx * (100 * rand() + 100)
    y = y + dy[i] * 50 * rand()
    Lume.push(t,x,y)
    i = i < 4 and i + 1 or 1
    dx = dx == 0 and 1 or 0
    if x >= self.worldWidth then break end
  end
  return t
end

function Play:drawParallax()
  g.setColor(255,255,255,32)
  self.parallax:push('layer0')
    g.line(self.vertices[1])
  self.parallax:pop()
  self.parallax:push('layer1')
    g.line(self.vertices[2])
  self.parallax:pop()
  self.parallax:push('layer2')
    g.line(self.vertices[3])
  self.parallax:pop()
end

function Play:draw()
  Push:start()
  g.clear(to_rgb(palette.bg))

  self:drawParallax()

  self.camera:draw(function(l,t,w,h)
    -- Only draw visible entities
    local items,len = self.world:queryRect(l,t,w,h)
    table.sort(items,Entity.sortByZOrder)
    Lume.each(items,'draw')
  end)
  Push:finish()
  Debug.draw()
end

function Play:onGameOver()
  Log.info('GAME OVER!')
  self:pushState('GameplayOut')
end

function Play:onResetGame()
  Log.info('Catch event: onResetGame')
  self.player:goToCheckPoint()
  self:pushState('GameplayIn')
end

function Play:update(dt)

  Timer.update(dt)
  Laser.updateEffect(dt)

  Debug.update('fps',love.timer.getFPS())

  local player = self.player
  -- TODO gameover
  if player.y > self.worldHeight then
    Beholder.trigger('Gameover')
  end

  self:updateShaders(dt,conf.shaderShift,1)

  -- Update visible entities
  -- TODO add a radius to update outside the visible windows
  local l,t,h,w = self.camera:getVisible()
  local items,len = self.world:queryRect(l,t,w,h)
  Lume.each(items,'update',dt)

  -- TODO smooth the camera. X doesnt work smoothly
  local x,y = self.camera:getPosition()
  local px, py = player:getCenter()
  self.camera:setPosition(px + conf.camOffsetX, Lume.lerp(y,py,0.05))
  self.parallax:setTranslation(px,py)
  -- self.parallax:update(dt)
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
  elseif key == 'p' then
    self:pushState('Paused')
  elseif key == 'c' then
    offsetHuePalette(conf.hueOffset)
  elseif key == 'd' then
    Debug.toogle()
  end
end

return Play
