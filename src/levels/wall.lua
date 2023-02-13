-- WALL
walls = {}
if gameMap.layers["walls"] then
  for i, obj in pairs(gameMap.layers["walls"].objects) do
    local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height) -- (x, y, width, height, mass)
    wall:setType("static")
    table.insert(walls, wall)
  end
end
