local createQueue = function()
  local queue = {}
  queue.__items = {}

  function queue:add(item)
    table.insert(queue.__items, item)
  end

  function queue:retrieve()
    if #queue.__items == 0 then
      return false
    end

    local item = queue.__items[1]
    table.remove(queue.__items, 1)

    return item
  end

  function queue:peek()
    return queue.__items[1]
  end

  function queue:getSize()
    return #queue.__items
  end

  return queue
end

return createQueue