local collision = require 'src/collision'

local createRectangle = require 'src/rectangle'

local ladder = {}
local ladderDim = {w = screenDim.x / 80, h = screenDim.y / 30}

local function createStack()
  local stack = {}
  stack.stacks = {}

  function stack:addStack(x, y, size)
    local newStack = {}
    newStack.box = createRectangle(x, y, ladderDim.w, ladderDim.h)
    newStack.size = size or 0

    table.insert(self.stacks, newStack)
  end

  function stack:findStack(pos)
    for i, currStack in ipairs(self.stacks) do
      if pos.x == currStack.box.x and pos.y == currStack.box.y then
        return i
      end
    end
  end

  -- function stack:findStacks(box)
  --   local found = {}
  --
  --   for i, currStack in ipairs(self.stacks) do
  --     if collision.axis(box, currStack.box, 'x', 'w') then
  --       table.insert(found, currStack)
  --     end
  --   end
  --
  --   return found
  -- end
  --
  -- function stack:isOnLadder(box)
  --   for _, currStack in ipairs(self:findStacks(box)) do
  --     if currStack.size > 0 then
  --       local currStackHitBox = {}
  --       currStackHitBox.x = currStack.box.x
  --       currStackHitBox.y = currStack.box.y
  --       currStackHitBox.w = currStack.box.w
  --       currStackHitBox.h = currStack.box.h * currStack.size
  --
  --       if collision.rectangles(currStackHitBox, box) then
  --         return true
  --       end
  --     end
  --   end
  -- end

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

  return stack
end

ladder.deposit = createRectangle(
  screenDim.x - screenDim.x / 40,
  0,
  screenDim.x / 40,
  screenDim.y / 30
)

ladder.stack = createStack()

ladder.display = function()
  love.graphics.setColor(200, 200, 100)
  love.graphics.rectangle('fill', ladder.deposit.x, ladder.deposit.y, ladder.deposit.w, ladder.deposit.h)
end

return ladder
