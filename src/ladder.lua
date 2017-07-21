local collision = require 'src/collision'

local createRectangle = require 'src/rectangle'

local ladder = {}
ladder.defaultDim = {w = 10, h = 15}

local function createStack()
  local stack = {}
  stack.stacks = {}

  function stack:addStack(x, y, size)
    local newStack = {}
    newStack.pos = {x = x, y = y}
    newStack.box = createRectangle(
      x + gold.defaultDim.w / 2 - ladder.defaultDim.w / 2,
      0,
      ladder.defaultDim.w,
      ladder.defaultDim.h
    )
    newStack.decaying = false
    newStack.time = 0

    newStack.size = size or 0

    table.insert(self.stacks, newStack)
  end

  function stack:findStack(pos)
    for i, currStack in ipairs(self.stacks) do
      if pos.x == currStack.pos.x and pos.y == currStack.pos.y then
        return i
      end
    end
  end

  function stack:getStackSize(pos)
    local currStack = self:findStack(pos)

    if currStack then
      return currStack.size
    end
  end

  function stack:isOnLadder(box, ladderPos)
    local ladderIndex = self:findStack(ladderPos)

    if ladderIndex then
      local currStack = self.stacks[ladderIndex]

      if currStack.size > 0 then
        local currStackHitBox = {}
        currStackHitBox.x = currStack.box.x
        currStackHitBox.y = currStack.box.y
        currStackHitBox.w = currStack.box.w
        currStackHitBox.h = currStack.box.h * currStack.size

        if collision.rectangles(currStackHitBox, box) then
          return true
        end
      end
    end
  end

  function stack:display()
    love.graphics.setColor(200, 200, 100)

    for _, currStack in ipairs(self.stacks) do
      for i=1, currStack.size do
          love.graphics.rectangle(
          'line',
          currStack.box.x,
          currStack.box.y + (i - 1) * currStack.box.h,
          currStack.box.w,
          currStack.box.h
        )
      end
    end
  end

  return stack
end

-- clean up code to have the deposit in the createStack class and remove the stack layer

ladder.deposit = createRectangle(screenDim.x - 20, 0, 20, 20)

ladder.stack = createStack()

ladder.update = function(dt)
  for i=#ladder.stack.stacks, 1, -1 do
    local currLadder = ladder.stack.stacks[i]

    if currLadder.decaying then
      if currLadder.time > 0.5 then
        currLadder.time = currLadder.time - 0.5
        currLadder.size = currLadder.size - 1
      end

      if currLadder.size < 1 then
        table.remove(ladder.stack.stacks, i)
      end

      currLadder.time = currLadder.time + dt
    end
  end
end

ladder.display = function()
  love.graphics.setColor(200, 200, 100)
  love.graphics.rectangle('fill', ladder.deposit.x, ladder.deposit.y, ladder.deposit.w, ladder.deposit.h)
  ladder.stack:display()
end

return ladder
