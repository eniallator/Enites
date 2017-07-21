local function createRectangle(x, y, w, h)
  local rectangle = {}
  rectangle.x = x
  rectangle.y = y
  rectangle.w = w
  rectangle.h = h

  function rectangle:getMid()
    return {
      x = self.x + self.w / 2,
      y = self.y + self.h / 2
    }
  end

  return rectangle
end

return createRectangle
