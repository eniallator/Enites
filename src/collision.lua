local collision = {}

local function collideAxis(box1, box2, axis, dim)
  if box1[axis] < box2[axis] + box2[dim] and box2[axis] <= box1[axis] + box1[dim] then
    return true
  end
end

collision.rectangles = function(box1,box2)
  if collideAxis(box1, box2, "x", "w") and collideAxis(box1, box2, "y", "h") then
    return true
  end
end

return collision
