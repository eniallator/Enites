local createEnite = require 'src/enite'

local enites = {}
enites.defaultDim = {w = screenDim.x / 160, h = screenDim.y / 60}
enites.population = {}

enites.createEnite = function(x, y)
  local newEnite = createEnite(
    x or math.random(screenDim.x - ladder.deposit.w),
    y or 0,
    enites.defaultDim.w,
    enites.defaultDim.h
  )

  table.insert(enites.population, newEnite)
end

enites.update = function(dt)
  for _, currEnite in ipairs(enites.population) do
    currEnite:update(dt)
  end
end

enites.display = function()
  love.graphics.setColor(0, 200, 0)

  for _, currEnite in ipairs(enites.population) do
    love.graphics.rectangle('fill', currEnite.box.x, currEnite.box.y, currEnite.box.w, currEnite.box.h)
  end
end

return enites
