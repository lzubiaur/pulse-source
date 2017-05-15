-- debug-output

local module = {}

local t = {}
local font = nil
local fontHeight = 0

function module.init()
  font = g.newFont('resources/fonts/roboto-condensed.fnt','resources/fonts/roboto-condensed.png')
  fontHeight = font:getHeight()
end

function module.draw()
  local oldFont = g.getFont()
  local i = 0
  g.setFont(font)
  for k,v in pairs(t) do
    g.print(k..':'..v,10,i * fontHeight)
    i = i + 1
  end
  g.setFont(oldFont)
end

function module.add(k,v)
  t[k] = v
end

function module.update(k,v)
  t[k] = v
end

return module
