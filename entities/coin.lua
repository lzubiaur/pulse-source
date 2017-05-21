-- coin.lua

local Entity = require 'entities.entity'

local Coin = Class('Coin',Entity):include(Stateful)

function Coin:initialize(world,x,y,w,h,opt)
  Entity.initialize(self,world,x,y,w,h,opt)
  if not self:restoreState() then
    self:observeOnce('Coin',self,function() self:pushState('Checked') end)
  end
end

-- function Coin:enteredState()
--   Log.debug('Entered state coin')
-- end

function Coin:draw()
  g.setColor(255,255,0,255)
  Entity.draw(self)
end

-- Coin "Checked" state
-- Checked state: player has touched the coin but will only be commited when on
-- the next checkpoint

local Checked = Coin:addState('Checked')

function Checked:enteredState()
  Log.info('Enter state "Coin Checked"')
  self:observeOnce('Checkpoint',function()
    self:saveState { name = 'Saved' }
    self:gotoState('Saved')
  end)
  self:observeOnce('Gameover',function()
    self:observeOnce('Coin',self,function() self:pushState('Checked') end)
    self:popState()
  end)
end

function Checked:draw()
  g.setColor(32,32,32,255)
  Entity.draw(self)
end

-- Coin "Saved" state
-- Player has commited the coin by touching the checkpoint. Saved
-- state in also restored on loading the world using the game state database.

local Saved = Coin:addState('Saved')

-- function Saved:enteredState()
-- end

function Saved:draw()
  g.setColor(60,60,60,255)
  Entity.draw(self)
end

return Coin
