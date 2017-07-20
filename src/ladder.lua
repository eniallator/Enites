local collision = require 'src/collision'

local createRectangle = require 'src/rectangle'

local ladder = {}
ladder.defaultDim = {w = screenDim.x / 80, h = screenDim.y / 30}

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

ladder.deposit = createRectangle(
  screenDim.x - screenDim.x / 40,
  0,
  screenDim.x / 40,
  screenDim.y / 30
)

ladder.decaying = {}

ladder.stack = createStack()

ladder.update = function(dt)
  for i=#ladder.decaying, 1, -1 do
    local currLadder = ladder.decaying[i]

    if currLadder.time > 1 then
      currLadder.time = currLadder.time - 1
      ladder.stack.stacks[currLadder.index].size = ladder.stack.stacks[currLadder.index].size - 1
    end

    print(serialise(ladder.stack.stacks), serialise(ladder.decaying))

    if ladder.stack.stacks[currLadder.index].size < 1 then
      table.remove(ladder.decaying, i)
      table.remove(ladder.stack.stacks, currLadder.index)
    end

    currLadder.time = currLadder.time + dt
  end
end

ladder.display = function()
  love.graphics.setColor(200, 200, 100)
  love.graphics.rectangle('fill', ladder.deposit.x, ladder.deposit.y, ladder.deposit.w, ladder.deposit.h)
  ladder.stack:display()
end

return ladder
