local createQueue = function(callbackOnRetrieve)
  local queue = {}
  queue.__items = {}
  queue.__callbackOnRetrieve = callbackOnRetrieve

  function queue:add(item)
    table.insert(queue.__items, item)
  end

  function queue:retrieve()
    if #self.__items == 0 then
      return false
    end

    local item = table.remove(self.__items, 1)

    if self.__callbackOnRetrieve then
      return self.__callbackOnRetrieve(item)
    end

    return item
  end

  function queue:dumpNext()
    if #self.__items == 0 then
      return false
    end

    table.remove(self.__items, 1)
  end

  function queue:peek()
    return self.__items[1]
  end

  function queue:getSize()
    return #self.__items
  end

  function queue:getItems()
    return self.__items
  end

  return queue
end

return createQueue
