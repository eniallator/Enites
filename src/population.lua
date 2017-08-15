local createEnite = require 'src/enite'

local population = {}
population = {}

population.createEnite = function(x, y)
  local emptySpawnSpace = screenDim.x - gold.collection.x - ladder.deposit.w
  local instance = createEnite(x or gold.collection.x + math.random(emptySpawnSpace), y or 0)

  table.insert(population, instance)
end

population.update = function(dt)
  for _, currEnite in ipairs(population) do
    currEnite:update(dt)
  end
end

population.display = function()
  for _, currEnite in ipairs(population) do
    if currEnite.tasks:getSize() > 0 then
      love.graphics.setColor(0, 200, 0)

    else
      love.graphics.setColor(200, 0, 0)
    end

    love.graphics.rectangle('fill', currEnite.box.x, currEnite.box.y, currEnite.box.w, currEnite.box.h)
  end
end

return population
