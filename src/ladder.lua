local ladder = {}

ladder.deposit = {}
ladder.deposit.pos = {x = screenDim.x - screenDim.x / 40, y = 0}
ladder.deposit.dim = {w = screenDim.x - ladder.deposit.pos.x, h = screenDim.y / 30}

ladder.display = function()
  love.graphics.setColor(200, 200, 100)
  love.graphics.rectangle('fill', ladder.deposit.pos.x, ladder.deposit.pos.y, ladder.deposit.dim.w, ladder.deposit.dim.h)
end

return ladder
