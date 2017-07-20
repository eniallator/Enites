local createRectangle = require 'src/rectangle'
local createQueue = require 'src/queue'

local gold = {}
gold.deposits = {}
gold.defaultDim = {w = screenDim.x / 40, h = screenDim.y / 30}

gold.newDeposits = createQueue(function(item)
  table.insert(gold.deposits, item)

  return #gold.deposits
end)

gold.createDeposit = function(x, y, value)
  local newGold = {}
  newGold.box = createRectangle(x, y, gold.defaultDim.w, gold.defaultDim.h)
  newGold.value = value or 1

  gold.newDeposits:add(newGold)

  ladder.stack:addStack(x, y)
end

gold.display = function()
  love.graphics.setColor(120, 120, 0)

  for _, currGold in ipairs(gold.deposits) do
    love.graphics.rectangle('fill', currGold.box.x, currGold.box.y, currGold.box.w, currGold.box.h)
  end
end

return gold
