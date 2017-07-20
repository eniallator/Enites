local collision = require 'src/collision'

local createRectangle = require 'src/rectangle'
local createQueue = require 'src/queue'

local eniteSpeed = screenDim.x / 200

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

        currEnite.inventory:delItem('ladder')
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
  newEnite.inventory = {items = {}}

  function newEnite.inventory:delItem(item)
    for i = #self.items, 1, -1 do
      if self.items[i] == item then
        table.remove(self.items, i)
        break
      end
    end
  end

  function newEnite.inventory:search(item)
    for i=1, #self.items do
      if self.items[i] == item then
        return true
      end
    end
  end

  newEnite.tasks = createQueue()

  function newEnite:update(dt)
    checkGold(self)
    local currTask = self.tasks:peek()

    if currTask and not gold.deposits[currTask.val] then
      self.tasks:dumpNext()
      return
    end

    if self.inventory:search('gold') then
      goTowardPos(self, gold.collection, eniteSpeed)

      if collision.rectangles(self.box, gold.collection) then
        self.inventory:delItem('gold')
      end

      return
    end

    if currTask and currTask.name == 'gold' and self.inventory:search('ladder') then
      goTowardPos(self, gold.deposits[currTask.val].box, eniteSpeed)
    end

    if collision.rectangles(self.box, ladder.deposit) and #self.inventory == 0 then
      table.insert(self.inventory.items, 'ladder')
    end

    if currTask and collision.rectangles(self.box, gold.deposits[currTask.val].box) then
      table.insert(ladder.decaying, {time = 0, index = ladder.stack:findStack(gold.deposits[currTask.val])})
      table.insert(self.inventory.items, 'gold')
      table.remove(gold.deposits, currTask.val)
      return
    end

    if #self.inventory.items == 0 then
      goTowardPos(self, ladder.deposit, eniteSpeed)
    end

    if not currTask and #gold.deposits > 0 then
      self.tasks:add({name = 'gold', val = math.random(#gold.deposits)})
    end
  end

  return newEnite
end

return createEnite
