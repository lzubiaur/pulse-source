-- coin.lua

local Entity = require 'entities.entity'

local Coin = Class('Coin',Entity):include(Stateful)

function Coin:initialize(world,x,y,w,h,opt)
  Log.debug('Create coin')
  Entity.initialize(self,world,x,y,w,h,opt)
  self:restoreState()
end

function Coin:draw()
  g.setColor(255,255,0,255)
  Entity.draw(self)
end

local Checked = Coin:addState('Checked')

function Checked:enteredState()
  Log.info('Enter state "Coin Checked"')
  local id = Beholder.observe('Checkpoint',function()
    Log.info('Save coin state',self.id)
    self:saveState {
      state = 'Saved'
    }
    Beholder.stopObserving(id)
  end)
end

function Checked:draw()
  g.setColor(32,32,32,255)
  Entity.draw(self)
end

local Saved = Coin:addState('Saved')

function Saved:enteredState()
  Log.info('Enter state "Coin Saved"')
end

function Saved:draw()
  g.setColor(60,60,60,255)
  Entity.draw(self)
end

return Coin
