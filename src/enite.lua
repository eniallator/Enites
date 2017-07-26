local collision = require 'src/collision'

local createRectangle = require 'src/rectangle'
local createQueue = require 'src/queue'

local function createEnite(x, y, w, h)
  local newEnite = {}

  newEnite.__speed = 48 * 4

  newEnite.box = createRectangle(x, y, w, h)
  newEnite.inventory = {items = {}}
  newEnite.tasks = createQueue()

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

  function newEnite:__applyMovement(pos, moveDist, axis)
    local eniteMid = self.box:getMid()

    if eniteMid[axis] > pos[axis] then
      self.box[axis] = self.box[axis] - moveDist[axis]

    elseif eniteMid[axis] < pos[axis] then
      self.box[axis] = self.box[axis] + moveDist[axis]
    end
  end

  function newEnite:__goTowardPos(pos, speed)
    local eniteMid = self.box:getMid()
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
        if ladder.stack:isOnLadder(self.box, pos) then
          self:__applyMovement(posMid, moveDist, 'y')

        else
          local currStack = ladder.stack.stacks[ladderIndex]
          currStack.size = currStack.size + 1

          self.inventory:delItem('ladder')
        end

      else
        self:__applyMovement(posMid, moveDist, 'y')
      end

    elseif self.box.y > 0 then
      self.box.y = self.box.y - speed

    else
      self:__applyMovement(posMid, moveDist, 'x')
    end
  end

  function newEnite:update(dt)
    local currTask = self.tasks:peek()
    local destination

    if currTask and not gold.deposits[currTask.val] then
      self.tasks:dumpNext()
      return
    end

    if self.box.y < 0 then
      self.box.y = 0
    end

    if self.inventory:search('gold') then
      destination = gold.collection

      if collision.rectangles(self.box, gold.collection) then
        self.inventory:delItem('gold')
      end

    elseif currTask and currTask.name == 'gold' and self.inventory:search('ladder') then
      destination = gold.deposits[currTask.val].box

    elseif #self.inventory.items == 0 then
      destination = ladder.deposit

    elseif self.box.y > 0 then
      destination = createRectangle(self.box.x, 0, 0, 0)
    end

    if collision.rectangles(self.box, ladder.deposit) and #self.inventory.items == 0 then
      table.insert(self.inventory.items, 'ladder')
    end

    if currTask and collision.rectangles(self.box, gold.deposits[currTask.val].box) then
      local stackPos = gold.deposits[currTask.val].box
      local stackIndex = ladder.stack:findStack(stackPos)
      ladder.stack.stacks[stackIndex].decaying = true

      for _, eniteToTell in pairs(enites.population) do
        if eniteToTell.tasks:peek() and (eniteToTell.tasks:peek()).val > currTask.val then
          local theirTasks = eniteToTell.tasks:getItems()
          theirTasks[1].val = theirTasks[1].val - 1
        end
      end

      table.insert(self.inventory.items, 'gold')
      table.remove(gold.deposits, currTask.val)
      return
    end

    if not currTask and gold.newDeposits:getSize() == 0 and #gold.deposits > 0 then
      self.tasks:add({name = 'gold', val = math.random(#gold.deposits)})

    elseif not currTask and gold.newDeposits:getSize() > 0 then
      self.tasks:add({name = 'gold', val = gold.newDeposits:retrieve()})
    end

    if destination then
      self:__goTowardPos(destination, self.__speed * dt)
    end
  end

  return newEnite
end

return createEnite
