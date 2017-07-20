local createRectangle = require 'src/rectangle'

local ladder = {}

ladder.deposit = createRectangle(
  screenDim.x - screenDim.x / 40,
  0,
  screenDim.x / 40,
  screenDim.y / 30
)

ladder.display = function()
  love.graphics.setColor(200, 200, 100)
  love.graphics.rectangle('fill', ladder.deposit.x, ladder.deposit.y, ladder.deposit.w, ladder.deposit.h)
end

return ladder
