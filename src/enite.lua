local createQueue = require 'src/queue'
local collision = require 'src/collision'

local eniteSpeed = screenDim.x / 400

local function checkGold(currEnite)
  if gold.newDeposits:getSize() > 0 and currEnite.tasks:getSize() == 0 then
    currEnite.tasks:add({name = 'gold', val = gold.newDeposits:retrieve()})
  end
end

local function applyMovement(currEnite, pos, moveDist, axis)
  if currEnite.pos[axis] > pos[axis] then
    currEnite.pos[axis] = currEnite.pos[axis] - moveDist[axis]

  elseif currEnite.pos[axis] < pos[axis] then
    currEnite.pos[axis] = currEnite.pos[axis] + moveDist[axis]
  end
end

local function goTowardPos(currEnite, pos, speed)
  local diff = {
    x = math.abs(currEnite.pos.x - pos.x),
    y = math.abs(currEnite.pos.y - pos.y)
  }

  local moveDist = {
    x = speed > diff.x and diff.x or speed,
    y = speed > diff.y and diff.y or speed
  }

  if currEnite.pos.x == pos.x then
    applyMovement(currEnite, pos, moveDist, 'y')

  elseif currEnite.pos.y > 0 then
    currEnite.pos.y = currEnite.pos.y - moveDist.y

  else
    applyMovement(currEnite, pos, moveDist, 'x')
  end
end

local function createEnite(w, h, x, y)
  local newEnite = {}
  newEnite.pos = {
    x = x or math.random(screenDim.x - ladder.deposit.dim.w),
    y = y or 0
  }
  newEnite.dim = {w = w, h = h}
  newEnite.inventory = {}

  newEnite.tasks = createQueue()

  function newEnite:update(dt)
    checkGold(self)
    local currTask = self.tasks:peek()

    if currTask and currTask.name == 'gold' then
      if collision.rectangles(self, ladder.deposit) and #self.inventory == 0 then
        table.insert(self.inventory, 'ladder')
      end

      if #self.inventory == 0 then
        goTowardPos(self, ladder.deposit.pos, eniteSpeed)

      else
        goTowardPos(self, gold.deposits[currTask.val].pos, eniteSpeed)
      end
    end
  end

  return newEnite
end

return createEnite
