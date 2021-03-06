local createRectangle = require 'src/rectangle'
local createQueue = require 'src/queue'

local gold = {}
gold.deposits = {}
gold.defaultDim = {w = 20, h = 20}

gold.collection = createRectangle(0, 0, 20, 20)

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

gold.update = function(dt)
  if mouse.left.clicked then
    gold.createDeposit(mouse.pos.x - gold.defaultDim.w / 2, screenDim.y - mouse.pos.y - gold.defaultDim.h / 2)
  end
end

local function displayGold(currGold)
  love.graphics.rectangle('fill', currGold.box.x, currGold.box.y, currGold.box.w, currGold.box.h)
end

gold.display = function()
  love.graphics.setColor(120, 120, 0)

  for _, currGold in ipairs(gold.deposits) do
    displayGold(currGold)
  end

  for _, currGold in ipairs(gold.newDeposits:getItems()) do
    displayGold(currGold)
  end

  love.graphics.rectangle('fill', gold.collection.x, gold.collection.y, gold.collection.w, gold.collection.h)
end

return gold
