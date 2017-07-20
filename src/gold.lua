local createQueue = require 'src/queue'

local gold = {}
gold.deposits = {}
gold.defaultDim = {w = screenDim.x / 40, h = screenDim.y / 30}

gold.newDeposits = createQueue()

gold.createDeposit = function(x, y, value)
  local newGold = {}
  newGold.pos = {x = x, y = y}
  newGold.dim = {w = gold.defaultDim.w, h = gold.defaultDim.h}
  newGold.value = value or 1

  table.insert(gold.deposits, newGold)

  gold.newDeposits:add(#gold.deposits)
end

gold.display = function()
  love.graphics.setColor(120, 120, 0)

  for _, currGold in ipairs(gold.deposits) do
    love.graphics.rectangle('fill', currGold.pos.x, currGold.pos.y, currGold.dim.w, currGold.dim.h)
  end
end

return gold
