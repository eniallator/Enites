local collision = require 'src/collision'

local createRectangle = require 'src/rectangle'
local createQueue = require 'src/queue'

local eniteSpeed = screenDim.x / 400

local function checkGold(currEnite)
  if gold.newDeposits:getSize() > 0 and currEnite.tasks:getSize() == 0 then
    currEnite.tasks:add({name = 'gold', val = gold.newDeposits:retrieve()})
  end
end

local function applyMovement(currEnite, pos, moveDist, axis)
  local eniteMid = currEnite.box:getMid()

  if eniteMid[axis] > pos[axis] then
    currEnite.box[axis] = currEnite.box[axis] - moveDist[axis]

  elseif eniteMid[axis] < pos[axis] then
    currEnite.box[axis] = currEnite.box[axis] + moveDist[axis]
  end
end

local function goTowardPos(currEnite, pos, speed)
  local eniteMid = currEnite.box:getMid()
  local posMid = pos:getMid()

  local diff = {
    x = math.abs(eniteMid.x - posMid.x),
    y = math.abs(eniteMid.y - pos.y)
  }

  local moveDist = {
    x = speed > diff.x and diff.x or speed,
    y = speed > diff.y and diff.y or speed
  }

  if eniteMid.x == posMid.x then
    local ladderIndex = ladder.stack:findStack(pos)

    if ladderIndex then
      if ladder.stack:isOnLadder(currEnite.box, pos) then
        applyMovement(currEnite, posMid, moveDist, 'y')

      else
        local currStack = ladder.stack.stacks[ladderIndex]
        currStack.size = currStack.size + 1

        for i=#currEnite.inventory, 1, -1 do
          if currEnite.inventory[i] == 'ladder' then
            table.remove(currEnite.inventory, i)
            break
          end
        end
      end

    else
      applyMovement(currEnite, posMid, moveDist, 'y')
    end

  elseif currEnite.box.y > 0 then
    currEnite.box.y = currEnite.box.y - moveDist.y

  else
    applyMovement(currEnite, posMid, moveDist, 'x')
  end
end

local function createEnite(x, y, w, h)
  local newEnite = {}
  newEnite.box = createRectangle(x, y, w, h)
  newEnite.inventory = {}

  newEnite.tasks = createQueue()

  function newEnite:update(dt)
    checkGold(self)
    local currTask = self.tasks:peek()

    if currTask and currTask.name == 'gold' then
      if collision.rectangles(self.box, ladder.deposit) and #self.inventory == 0 then
        table.insert(self.inventory, 'ladder')
      end

      if #self.inventory == 0 then
        goTowardPos(self, ladder.deposit, eniteSpeed)

      else
        goTowardPos(self, gold.deposits[currTask.val].box, eniteSpeed)
      end
    end
  end

  return newEnite
end

return createEnite
