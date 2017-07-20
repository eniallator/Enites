local createEnite = require 'src/enite'

local enites = {}
enites.defaultDim = {w = screenDim.x / 160, h = screenDim.y / 60}
enites.population = {}

enites.createEnite = function(x, y, velX, velY)
  local newEnite = createEnite(enites.defaultDim.w, enites.defaultDim.h, x, y, velX, velY)

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
    love.graphics.rectangle('fill', currEnite.pos.x, currEnite.pos.y, currEnite.dim.w, currEnite.dim.h)
  end
end

return enites
